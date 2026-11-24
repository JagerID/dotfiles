#!/bin/bash
# notif-hover.sh enter <id> | leave <id>
# Пишет id уведомления под курсором, его читает notifs.sh.
F="${XDG_RUNTIME_DIR:-/tmp}/eww-notif-hover"
case "$1" in
	enter) echo "$2" >"$F" ;;
	leave) [ "$(cat "$F" 2>/dev/null)" = "$2" ] && rm -f "$F" ;;
esac
exit 0
