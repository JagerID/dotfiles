#!/bin/bash
# Poll-скрипт для eww: отдаёт активные уведомления mako в JSON.
# Таймаут считаем сами (mako стоит с default-timeout=0 и не закрывает по таймеру):
#   - pct (100 -> 0) = сколько осталось до закрытия;
#   - пока на уведомление навели курсор (см. notif-hover.sh) отсчёт стоит
#     и запоминает, где остановился; при уходе курсора продолжается;
#   - по истечении времени уведомление закрывается через makoctl dismiss.
# Пока что-то под курсором, замораживаются все таймеры, чтобы JSON не менялся
# и eww не пересоздавал виджеты (иначе сбрасывался бы скролл).

TIMEOUT=6000    # мс
BODY_CPL=42     # символов в строке тела при развёрнутом виде (подгонка высоты)
COLLAPSED_LIM=44 # должен совпадать с :limit-width у свёрнутого тела в eww.yuck
LINE_PX=15      # высота строки тела, px
MAX_BODY_PX=150 # потолок высоты тела; выше - скролл

RT="${XDG_RUNTIME_DIR:-/tmp}"
STATE="$RT/eww-notifs-seen.json"
HOVER="$RT/eww-notif-hover"

list=$(makoctl list -j 2>/dev/null)
[ -z "$list" ] && list='[]'

old=$(cat "$STATE" 2>/dev/null)
[ -z "$old" ] && old='{}'
hov=$(cat "$HOVER" 2>/dev/null)
[ -z "$hov" ] && hov=-1

now=$(date +%s%3N)

res=$(jq -c --argjson old "$old" --argjson now "$now" --argjson t "$TIMEOUT" \
	--argjson hov "$hov" --argjson cpl "$BODY_CPL" --argjson lpx "$LINE_PX" \
	--argjson maxh "$MAX_BODY_PX" --argjson lim "$COLLAPSED_LIM" '
	def wrap_text($w): split("\n") | map(
		split(" ") | reduce .[] as $x ([];
			if length == 0 then [$x]
			elif (.[-1] | length) + 1 + ($x | length) <= $w then .[-1] += " " + $x
			else . + [$x] end) | join("\n")) | join("\n");
	map(. + {key: ([.id, .summary, .body] | tojson)}) as $cur
	| (any($cur[]; .id == $hov)) as $frozen
	| (($old._last // $now) as $last
	   | ([($now - $last), 0] | max | [., 1000] | min)) as $dt
	| (reduce $cur[] as $n ({}; .[$n.key] = (($old[$n.key] // 0) + (if $frozen then 0 else $dt end)))) as $el
	| {
		state: ($el + {_last: $now}),
		expired: [$cur[] | select($el[.key] >= $t) | .id],
		out: ($cur | map(select($el[.key] < $t)) | reverse | .[:5] | map(
			. + {
				pct: ([0, 100 - (100 * $el[.key] / $t)] | max | floor),
				hovered: (.id == $hov),
				truncated: ((.body // "" | length) > $lim),
				body_full: ((.body // "") | wrap_text($cpl)),
				body_h: ([ ((((.body // "") | wrap_text($cpl)) | split("\n") | length) * $lpx), $maxh ] | min)
			}
			| del(.key)
		))
	}
' <<<"$list" 2>/dev/null) || { echo '[]'; exit 0; }

[ -z "$res" ] && { echo '[]'; exit 0; }

jq -c .state <<<"$res" >"$STATE.$$" && mv -f "$STATE.$$" "$STATE"
for id in $(jq -r '.expired[]' <<<"$res"); do
	makoctl dismiss -n "$id" >/dev/null 2>&1
done
jq -c .out <<<"$res"
