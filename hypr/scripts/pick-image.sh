#!/bin/sh
# Usage: pick-image.sh [DIR]   (default ~/Pictures)
# Browse the filesystem with fuzzel starting at DIR: ".." goes up, "name/" enters a folder,
# an image (newest first) opens in imv together with the other images of its folder.
# Esc leaves.
dir="${1:-$HOME/Pictures}"
dir=$(cd "$dir" 2>/dev/null && pwd -P) || dir="$HOME"

while :; do
    pick=$({
        [ "$dir" != / ] && echo ".."
        find "$dir" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -printf '%P/\n' | sort
        find "$dir" -mindepth 1 -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
            -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.bmp' -o -iname '*.tiff' \) -printf '%T@ %P\n' \
            | sort -rn | cut -d' ' -f2-
    } | fuzzel --dmenu -p "$dir> ") || exit 0
    [ -n "$pick" ] || exit 0
    case "$pick" in
        ..) dir=$(dirname "$dir") ;;
        */) dir="${dir%/}/${pick%/}" ;;
        *)  exec imv -n "${dir%/}/$pick" "$dir" ;;
    esac
done
