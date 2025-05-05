#!/bin/sh

[ -z "$1" ] && { echo "Please provide a command (next, play-pause, previous, stop)."; exit 1; }

pgrep -x "mpv" > /dev/null && {
mpc() { echo "$1" |   socat - /tmp/mpv ; exit 0; }
case "$1" in
"next") mpc "playlist-next" ;;
"previous") mpc "playlist-prev" ;;
"play-pause") mpc "cycle pause"  ;;
*) exit 1 ;;
esac
}

mpris() {
players=$(dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep 'org.mpris.MediaPlayer2' | awk -F '"' '{print $2}')
for x in $players; do
dbus-send --session --dest="$x" --type=method_call /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player."$1"
done
}

case "$1" in
"next") mpris "Next" ;;
"play-pause") mpris "PlayPause" ;;
"previous") mpris "Previous" ;;
"stop") mpris "Stop" ;;
*) exit 1  ;;
esac
