#!/bin/bash
# Save the weather location (empty = auto-detect), close the input popup, refresh.
f="${XDG_CONFIG_HOME:-$HOME/.config}/eww/location"
loc=$(printf '%s' "$1" | tr -d '\r\n' | sed 's/^ *//; s/ *$//')
if [ -n "$loc" ]; then printf '%s\n' "$loc" > "$f"; else rm -f "$f"; fi
eww close weather-input 2>/dev/null
eww update WEATHER="$("$(dirname "$0")/weather.sh")"
