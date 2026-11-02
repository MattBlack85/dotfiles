#!/bin/bash
# Active keyboard layout as a flag + code for the eww bar, e.g. "🇮🇹 IT".
km=$(hyprctl devices -j 2>/dev/null | jq -r '[.keyboards[] | select(.main)][0].active_keymap // empty')
case "$km" in
    Italian*)       echo "🇮🇹 IT" ;;
    "English (US)"*) echo "🇺🇸 US" ;;
    "")             echo "⌨ ??" ;;
    *)              echo "⌨ $(echo "$km" | cut -c1-2 | tr '[:lower:]' '[:upper:]')" ;;
esac
