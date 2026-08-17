#!/bin/bash

WALLPAPER_DIR="$HOME/.config/wallpapers"
INTERVAL=1200

if [ ! -d "$WALLPAPER_DIR" ]; then
	echo "Директория '$WALLPAPER_DIR' не найдена" >&2
	exit 1
fi

if ! pgrep -x "awww-daemon" > /dev/null; then
	awww-daemon & sleep 1
fi

while true; do
	WALLPAPER=$(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) | shuf -n 1)

	echo "$WALLPAPER"

	if [ -n "$WALLPAPER" ]; then
		awww img -n wallpaper --transition-type random --transition-step 2 --transition-fps 120 "$WALLPAPER"
	fi

	sleep "$INTERVAL"
done
