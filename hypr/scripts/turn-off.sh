#!/bin/bash
# Back up the main disk and power off. The root part is /usr/local/bin/turn-off-root
# (installed from bin/turn-off-root); pkexec asks for the password via hyprpolkitagent.
# While it runs, one dunst notification (replaced in place) shows a spinner, the stage
# and a progress bar read from /run/turn-off.status. Used by SUPER+CTRL+K and the eww bar.
STATUS=/run/turn-off.status
TAG="x-dunst-stack-tag:turn-off"

if [ ! -x /usr/local/bin/turn-off-root ]; then
    notify-send -u critical "Turn off" "/usr/local/bin/turn-off-root is not installed (see bin/turn-off-root)"
    exit 1
fi

# one run at a time
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/turn-off.lock"
flock -n 9 || { notify-send -h "string:$TAG" "Turn off" "Already running"; exit 1; }

note() { notify-send -t 0 -h "string:$TAG" -h "int:value:$1" "$2  Turn off" "$3"; }

pkexec /usr/local/bin/turn-off-root &
pid=$!

frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
i=0
while kill -0 "$pid" 2>/dev/null; do
    pct=0; msg="Waiting for the password"
    if [ -r "$STATUS" ]; then
        IFS=$'\t' read -r pct msg < "$STATUS"
        msg="$msg (${pct}%)"
    fi
    note "${pct:-0}" "${frames[i % ${#frames[@]}]}" "$msg"
    i=$((i + 1))
    sleep 1
done

if wait "$pid"; then
    note 100 "" "Done, powering off"
else
    notify-send -u critical -h "string:$TAG" "Turn off" "Cancelled or backup failed, not powering off"
fi
