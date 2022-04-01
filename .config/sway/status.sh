
DATE=$(date "+ %a-%b-%d-%Y  %I:%M:%S %p")

BATSTAT=$(cat /sys/class/power_supply/BAT0/status)
BATPERC=$(cat /sys/class/power_supply/BAT0/capacity)

VSTAT="$(amixer get Master)"
VMUTE="  "

echo "$VSTAT" | grep "\[off\]" >/dev/null && VMUTE=" "
VOLUME=$(echo "$VSTAT" | grep -o "\[[0-9]\+%\]" | sed "s/[^0-9]*//g;1q")

WIFI="$(awk '/^\s*w/ { print "" }' /proc/net/wireless)"

KBLAYOUT=$(swaymsg -t get_inputs | grep -m1 'xkb_active_layout_name' |  awk -F '"' '{print $4}')


BNESS="$(brightnessctl get)"
MAX="$(brightnessctl max)"
BLPERC="$((BNESS*100/MAX))"

echo  $KBLAYOUT  $BLPERC  $VMUTE $VOLUME  $WIFI   $BATPERC% $BATSTAT $DATE
