#export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"
#complete -cf doas 

export NO_AT_BRIDGE=1
export PATH=$HOME/.local/bin:$PATH
#export _JAVA_AWT_WM_NONREPARENTING=1
#        export QT_QPA_PLATFORM=wayland
#export XDG_CURRENT_DESKTOP=sway
export MOZ_ENABLE_WAYLAND=1
# export GDK_BACKEND=wayland 
# export QT_QPA_PLATFORMTHEME=qt5ct


#export XCURSOR_PATH=${XCURSOR_PATH}:~/.icons

export NNN_OPENER=~/.config/nnn/plugins/nuke
export NNN_FIFO=/tmp/nnn.fifo
#export NNN_PLUG='d:dragdrop'

#export SUDO_ASKPASS=$HOME/.local/bin/dpass

if test -z "${XDG_RUNTIME_DIR}"; then
  export XDG_RUNTIME_DIR=/tmp/$(id -u)-runtime-dir
  if ! test -d "${XDG_RUNTIME_DIR}"; then
    mkdir "${XDG_RUNTIME_DIR}"
    chmod 0700 "${XDG_RUNTIME_DIR}"
  fi
fi

[[ -t 0 && $(tty) == /dev/tty1 && ! $DISPLAY ]] && sway
