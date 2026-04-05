#!/bin/bash

get_lang() {
	LANG=$(niri msg --json keyboard-layouts | jq -r ".names[.current_idx]" | awk '{print $1}')

	case "$LANG" in
		English) eww update lang="EN" ;;
		Russian) eww update lang="RU"
	esac
}

if [ -z "$1" ]; then
	get_lang

	exit 0
fi

if [ "$1" == "--watch" ]; then
	get_lang

	niri msg event-stream | while read -r line; do
		if echo "$line" | grep -q "Keyboard layout switched"; then
			get_lang
		fi
	done
fi
