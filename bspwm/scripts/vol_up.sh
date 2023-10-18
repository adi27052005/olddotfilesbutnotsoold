#!/bin/zsh
pactl set-sink-volume @DEFAULT_SINK@ +5%; notify-send "Volume: $(pactl get-sink-volume 0 | cut -d '/' -f2 | sed -n '1p' | awk '{print $1}')" -t 700
