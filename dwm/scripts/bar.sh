#!/bin/bash

battery(){
	script="$(acpi | cut -d ',' -f2 | awk '{print $1}')"

	battery_percentage="$(acpi | cut -d ',' -f2 | awk '{print $1}' | cut -d '%' -f1)"
	if (( $battery_percentage <= 20 )); then
		icon=
	elif (( $battery_percentage <= 40 )); then
		icon=
	elif (( $battery_percentage <= 60 )); then
		icon=
	elif (( $battery_percentage <= 80 )); then
		icon=
	elif (( $battery_percentage <= 100 )); then
		icon=
	fi

	status=$(acpi | cut -d ',' -f1 | cut -d ':' -f2 | awk '{print $1}')
	case $status in
		'Discharging') arrow="";;
		'Charging') arrow="";;
	esac

	bg="#e06c75"
	fg="#111111"
	bgalt="#282c34"
	fgalt="#bbbbbb"
	echo "^c$fg^^b$bg^ $icon  ^c$fgalt^^b$bgalt^ $arrow $script  ^d^"
}
settime(){
	script="$(date '+%I:%M %P')"
	icon=""
	bg="#c678dd"
	fg="#111111"
	bgalt="#282c34"
	fgalt="#bbbbbb"
	echo "^c$fg^^b$bg^ $icon  ^c$fgalt^^b$bgalt^ $script  ^d^"
}
cal(){
	script="$(date '+%d %b, %a')"
	icon=""
	bg="#98c379"
	fg="#111111"
	bgalt="#282c34"
	fgalt="#bbbbbb"
	echo "^c$fg^^b$bg^ $icon  ^c$fgalt^^b$bgalt^ $script  ^d^"
}
vol(){
	script="$(pactl get-sink-volume @DEFAULT_SINK@ | cut -d '/' -f2 | sed -n '1p' | awk '{print $1}')"
	mute_status="$(pactl get-sink-mute @DEFAULT_SINK@)"
	case $mute_status in
		"Mute: no") icon="󰕾";;
		"Mute: yes") icon="󰖁"; script="^c#777777^Muted";;
	esac
	bg="#c678dd"
	fg="#111111"
	bgalt="#282c34"
	fgalt="#bbbbbb"
	echo "^c$fg^^b$bg^ $icon  ^c$fgalt^^b$bgalt^ $script  ^d^"
}
brightness(){
	script="$(sudo ybacklight -get | cut -d '.' -f1)%"
	icon="󱩏"
	bg="#61afef"
	fg="#111111"
	bgalt="#282c34"
	fgalt="#bbbbbb"
	echo "^c$fg^^b$bg^ $icon  ^c$fgalt^^b$bgalt^ $script  ^d^"
}
# update(){
# 	script="$(paru -Qu | wc -l)"
# 	icon="󱕎"
# 	bg="#e06c75"
# 	fg="#111111"
# 	bgalt="#282c34"
# 	fgalt="#bbbbbb"
# 	echo "^c$fg^^b$bg^ $icon  ^c$fgalt^^b$bgalt^ $script Updates ^d^"
# }
sep(){
	echo ""
}
name="$(vol)$(sep)$(brightness)$(sep)$(battery)$(sep)$(cal)$(sep)$(settime)"
echo $name

xsetroot -name "$name"
