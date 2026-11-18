#!/bin/bash
# Poll-скрипт для eww: отдаёт активные уведомления mako в JSON
# и считает pct (100 -> 0) = сколько осталось до таймаута.
# Состояние (когда уведомление впервые увидели) хранится в $XDG_RUNTIME_DIR.

TIMEOUT=6000   # мс, должен совпадать с default-timeout в ~/.config/mako/config
STATE="${XDG_RUNTIME_DIR:-/tmp}/eww-notifs-seen.json"

list=$(makoctl list -j 2>/dev/null)
[ -z "$list" ] && list='[]'

old=$(cat "$STATE" 2>/dev/null)
[ -z "$old" ] && old='{}'

now=$(date +%s%3N)

res=$(jq -c --argjson old "$old" --argjson now "$now" --argjson t "$TIMEOUT" '
	map(. + {key: ([.id, .summary, .body] | tojson)})
	| (reduce .[] as $n ({}; .[$n.key] = ($old[$n.key] // $now))) as $seen
	| {
		state: $seen,
		out: (reverse | .[:5] | map(
			. + {pct: ([0, 100 - (100 * ($now - $seen[.key]) / $t)] | max | floor)}
			| del(.key)
		))
	}
' <<<"$list" 2>/dev/null) || { echo '[]'; exit 0; }

[ -z "$res" ] && { echo '[]'; exit 0; }

jq -c .state <<<"$res" >"$STATE"
jq -c .out <<<"$res"
