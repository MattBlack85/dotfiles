#!/bin/bash
# Show/hide the keybinds popup on the focused monitor (bound to SUPER+SHIFT+H).
if eww active-windows 2>/dev/null | grep -q '^keys:'; then
    eww close keys
    exit 0
fi
mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .id')
eww update KEYS="$("$(dirname "$0")/keys.sh")"
eww open keys --arg monitor="${mon:-0}"
