#!/bin/bash
# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
polybar-msg cmd quit
polybar -c $HOME/.config/bspwm/polybar/config.ini workspaces &
polybar -c $HOME/.config/bspwm/polybar/config.ini window &
polybar -c $HOME/.config/bspwm/polybar/config.ini date &
polybar -c $HOME/.config/bspwm/polybar/config.ini stuff &
polybar -c $HOME/.config/bspwm/polybar/config.ini bspwm-mode &
