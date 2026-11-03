#!/bin/bash
# Current weather from Open-Meteo (no API key), e.g. "Wieliczka ☁️ +5°C".
# Location: first line of ~/.config/eww/location if set (geocoded by name),
# else guessed from the IP (ipwho.is).
# Change it by clicking the weather item in the bar (see set_location.sh).
# (Was wttr.in, which started refusing connections on 2026-11-03.)
f="${XDG_CONFIG_HOME:-$HOME/.config}/eww/location"
want=$(head -n1 "$f" 2>/dev/null)
curl_j() { curl -sf --max-time 5 "$@"; }

fail() { [ -n "$want" ] && echo "? ${want}" || echo "n/a"; exit 0; }

if [ -n "$want" ]; then
    geo=$(curl_j -G "https://geocoding-api.open-meteo.com/v1/search" \
        --data-urlencode "name=$want" -d count=1 -d language=en -d format=json) || fail
    place=$(jq -r '.results[0] | select(. != null) | "\(.name)|\(.latitude)|\(.longitude)"' <<<"$geo")
else
    geo=$(curl_j "https://ipwho.is/") || fail
    place=$(jq -r 'select(.success == true) | "\(.city)|\(.latitude)|\(.longitude)"' <<<"$geo")
fi
[ -n "$place" ] || fail
IFS='|' read -r name lat lon <<<"$place"

cur=$(curl_j "https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,weather_code") || fail
temp=$(jq -r '.current.temperature_2m | select(. != null) | round' <<<"$cur")
code=$(jq -r '.current.weather_code | select(. != null)' <<<"$cur")
[ -n "$temp" ] && [ -n "$code" ] || fail

# WMO weather code -> emoji
case "$code" in
    0)             icon="☀️" ;;
    1)             icon="🌤️" ;;
    2)             icon="⛅" ;;
    3)             icon="☁️" ;;
    45|48)         icon="🌫️" ;;
    51|53|55|56|57) icon="🌦️" ;;
    61|63|65|66|67|80|81|82) icon="🌧️" ;;
    71|73|75|77|85|86)       icon="❄️" ;;
    95|96|99)      icon="⛈️" ;;
    *)             icon="🌡️" ;;
esac

[ "$temp" -ge 0 ] && temp="+${temp}"
echo "${name} ${icon} ${temp}°C"
