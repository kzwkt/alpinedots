local options = {musixmatch_token = '2409244c3e6cd327eab6e43182188c8a7893ad1879945c6c30e25b'}
local allowed_ext = {mp3 = true, flac = true}

mp.register_event('file-loaded', function()
    local path = mp.get_property('path')
    local ext = path:match("([^%.]+)$")
    if not allowed_ext[ext] then return end


    -- Check existing LRC in same directory
    local lrc = path:gsub('%.'..ext..'$', '.lrc')
    if io.open(lrc, 'r') then return end
    
    -- Get basic metadata
    local meta = mp.get_property_native('metadata') or {}
    local title, artist = meta.TITLE or meta.title, meta.ARTIST or meta.artist
    if not title or not artist then return end

    -- Fetch lyrics
    local result = mp.command_native({
        name = 'subprocess',
        capture_stdout = true,
        args = {
            'curl', '-s', '-G',
            '--cookie', 'x-mxm-token-guid='..options.musixmatch_token,
            'https://apic-desktop.musixmatch.com/ws/1.1/macro.subtitles.get',
            '--data', 'app_id=web-desktop-app-v1.0',
            '--data', 'usertoken='..options.musixmatch_token,
            '--data-urlencode', 'q_track='..title,
            '--data-urlencode', 'q_artist='..artist
        }
    })
    
    if not result.stdout then return end
    
    local res = (require 'mp.utils').parse_json(result.stdout)
    if not res or res.message.header.status_code ~= 200 then return end

    -- Extract and save lyrics
    local lyrics = res.message.body.macro_calls['track.subtitles.get'] 
        and res.message.body.macro_calls['track.subtitles.get'].message.body.subtitle_list[1].subtitle.subtitle_body
        or ''

    if lyrics ~= '' then
        io.open(lrc, 'w'):write(lyrics):close()
        mp.command('rescan-external-files')  -- Refresh subtitles
        mp.osd_message('Lyrics loaded')
    end
end)
