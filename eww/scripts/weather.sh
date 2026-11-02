#!/bin/bash
# Current weather from wttr.in, e.g. "Gdów ☀️ +12°C".
# Location: first line of ~/.config/eww/location if set, else guessed from IP.
# Change it by clicking the weather item in the bar (see set_location.sh).
f="${XDG_CONFIG_HOME:-$HOME/.config}/eww/location"
want=$(head -n1 "$f" 2>/dev/null)
path=""
[ -n "$want" ] && path=$(jq -rn --arg l "$want" '$l|@uri')
out=$(curl -sf --max-time 5 "https://wttr.in/${path}?format=%l|%c%t") || { [ -n "$want" ] && echo "? ${want}" || echo "n/a"; exit 0; }
case "$out" in *"Unknown location"*|*"Sorry"*) echo "? ${want}"; exit 0;; esac
loc=${out%%|*}; wx=${out#*|}
loc=${loc%%,*}   # "Gdów, Lesser Poland, PL" -> "Gdów"
echo "${loc} ${wx}"
