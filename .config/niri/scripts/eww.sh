#!/bin/bash

focused_output () {
	niri msg --json focused-output 2>/dev/null | jq -r '.model // empty'
}

# Окно уведомлений показываем на мониторе с фокусом (eww принимает model, а не имя коннектора)
open_notifs () {
	local out
	out=$(focused_output)
	[ -z "$out" ] && out=0
	eww close notifications 2>/dev/null
	eww open notifications --id "notifications" --arg mon="$out"
}

# Следим за сменой активного монитора и переносим окно уведомлений
watch_focus () {
	local cur new
	cur=$(focused_output)
	while sleep 0.3; do
		new=$(focused_output)
		if [ -n "$new" ] && [ "$new" != "$cur" ]; then
			cur=$new
			open_notifs
		fi
	done
}

load_eww () {
	echo "Запуск eww виджетов"
	eww close-all 2>/dev/null

	readarray -t outputs < <(niri msg --json outputs | jq -r 'to_entries[] | select(.value.current_mode != null) | .key' 2>/dev/null)

	h=30
	lw=200
	cw=130

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

		# уведомления только на первом мониторе

		eww open bg-centered \
		    --id "bg-centered-$mon" \
		    --arg mon="$mon"
	done

	open_notifs
}

if ! pgrep -x "eww" > /dev/null; then
    eww daemon & sleep 1
fi

load_eww

if [ "$1" = "--daemon" ]; then
    watch_focus &
    echo "Запущен режим демона. Ожидание событий изменения мониторов..."
    niri msg --json event-stream | grep --line-buffered -i "output" | while read -r line; do
        load_eww
    done
fi
