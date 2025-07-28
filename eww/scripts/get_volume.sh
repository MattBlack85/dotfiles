#!/bin/bash
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

if [ "$muted" = "yes" ]; then
    echo "MUTED"
else
    echo "$vol"
fi
