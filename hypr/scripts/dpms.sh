#!/bin/bash
# Turn all screens off/on (Hyprland 0.57 Lua dispatcher). Used by hypridle.
case "$1" in
    on|off) hyprctl dispatch "hl.dsp.dpms({ action = \"$1\" })" >/dev/null ;;
    *) echo "usage: $0 on|off" >&2; exit 2 ;;
esac
