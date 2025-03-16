#!/bin/sh

common() {
    printf "{\"color\":\"#000000\",\"background\":\"$bg\",\"full_text\":\"$stat\"},"
}


mydate() {
bg="#E0E0E0"
stat=$(date "+%a-%b-%d %H:%M")
common
}

volume() {
bg="#673AB7"
volstat=$(amixer get Master)
vol=$(echo "$volstat" | grep -o "\[[0-9]\+%\]" | sed "s/[^0-9]*//g;1q")    
echo "$volstat" | grep "\[off\]" >/dev/null && bg="FF0000" && vol=" "
stat="$vol"
common
}


battery() {
bg="#D69E2E"
prct=$(cat /sys/class/power_supply/BAT0/capacity)
chrg=$(cat /sys/class/power_supply/BAT0/status)
icon=" "
case $chrg in
"Charging")  icon="󰂄";bg="#0000ff"; ;;
"Not charging") icon="󰠑" ;bg="#ff0000" ;;
"Unknown") icon="";bg="ff00ff" ;;
"Full") icon="⚡"; bg="ffff00" ;;
esac 
stat=$icon\ $prct
common
}

echo '{ "version": 1 , "click_events":false}'
echo -n  "["

while :; do
echo -n  "["
    mydate
    volume
    battery
     sleep 1
echo -n  "],"
done
