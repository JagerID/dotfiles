#!/bin/bash

load_eww () {
	echo "Запуск eww виджетов"
	eww close-all 2>/dev/null

	readarray -t outputs < <(niri msg --json outputs | jq -r 'to_entries[] | select(.value.current_mode != null) | .key' 2>/dev/null)

	h=30
	lw=200
	cw=100
	rw=70

	if [ ${#outputs[@]} -eq 0 ]; then
		outputs=("0")
	fi

	for mon in "${!outputs[@]}"; do
		echo "Запуск виджетов для монитора $mon"

		eww open island \
		    --id "island-left-$mon" \
		    --arg x="5" \
		    --arg y="5" \
		    --arg w="$lw" \
		    --arg h="$h" \
		    --arg anch="top left" \
		    --arg mon="$mon" \
		    --arg content="(box :orientation \"horizontal\" :space-evenly false :spacing 10 \
			(cpu)(v-separator)(ram))"

		eww open island \
		    --id "island-center-$mon" \
		    --arg x="0" \
		    --arg y="5" \
		    --arg w="$cw" \
		    --arg h="$h" \
		    --arg anch="top center" \
		    --arg mon="$mon" \
		    --arg content="(box :orientation \"horizontal\" :space-evenly false :spacing 10 \
			(time))"

		eww open island \
		    --id "island-right-$mon" \
		    --arg x="5" \
		    --arg y="5" \
		    --arg w="$rw" \
		    --arg h="$h" \
		    --arg anch="top right" \
		    --arg mon="$mon" \
		    --arg content="(box :orientation \"horizontal\" :space-evenly false :spacing 10 \
			(power))"
	done
}

if ! pgrep -x "eww" > /dev/null; then
    eww daemon
fi

load_eww

if [ "$1" = "--daemon" ]; then
    echo "Запущен режим демона. Ожидание событий изменения мониторов..."
    niri msg --json event-stream | grep --line-buffered -i "output" | while read -r line; do
        load_eww
    done
fi
