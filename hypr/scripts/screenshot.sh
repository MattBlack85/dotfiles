#!/bin/sh
# Screenshot saved to ~/Pictures/screenshots and copied to the clipboard.
#   screenshot.sh all       both screens
#   screenshot.sh DP-3      one output (screen 1 = DP-3 left, screen 2 = DP-2 right)
#   screenshot.sh region    area picked with slurp
dir="$HOME/Pictures/screenshots"
mkdir -p "$dir"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"
case "$1" in
    all)    grim "$file" || exit 1 ;;
    region) geom=$(slurp) || exit 0   # Esc / right click cancels
            grim -g "$geom" "$file" || exit 1 ;;
    *)      grim -o "$1" "$file" || exit 1 ;;
esac
wl-copy < "$file" && notify-send -t 2000 "Screenshot saved" "$file"
