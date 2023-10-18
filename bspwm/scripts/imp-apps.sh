#!/usr/bin/env bash

case $(echo -e "Wallpaper\nFiles" | dmenu) in
	"Wallpaper") kitty -e ranger --choosefile=temp; feh --bg-fill $(cat temp); rm temp;;
	"Files") kitty -e ranger;;
esac
