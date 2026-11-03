#!/bin/bash
# Cyberpunk idle screensaver: each monitor's wallpaper, animated by a GPU shader (neon-saver.py).
# Used by hypridle (see ../hypridle.conf):   screensaver.sh start | stop
# Needs: python-gobject, gtk-layer-shell, python-pillow, jq.
DIR="$(cd "$(dirname "$0")" && pwd)"
WALLS="$HOME/.local/share/wallpapers"
PATTERN='^python3 .*/neon-saver\.py'

case "$1" in
    start)
        pgrep -f "$PATTERN" >/dev/null && exit 0               # already running
        hyprctl monitors -j | jq -r '.[] | "\(.id) \(.name)"' | while read -r id name; do
            case "$name" in
                DP-3) img="$WALLS/second.jpg" ;;
                *)    img="$WALLS/main.png" ;;
            esac
            [ -f "$img" ] || continue
            setsid python3 "$DIR/neon-saver.py" --index "$id" --image "$img" >/dev/null 2>&1 &
        done
        ;;
    stop)
        pkill -f "$PATTERN"
        ;;
    *)
        echo "usage: $0 start|stop" >&2; exit 2
        ;;
esac
exit 0
