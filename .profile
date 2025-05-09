if [ -z "$XDG_RUNTIME_DIR" ]; then
	XDG_RUNTIME_DIR="/tmp/$(id -u)-runtime-dir"

	mkdir -pm 0700 "$XDG_RUNTIME_DIR"
	export XDG_RUNTIME_DIR
fi

PATH="$HOME/.bin:$PATH"

[ -z "$WAYLAND_DISPLAY" ] && tty="/dev/tty1" && dbus-run-session sway
