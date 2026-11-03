#!/bin/bash
# Back up the main disk and power off. The root part is /usr/local/bin/turn-off-root
# (installed from bin/turn-off-root); pkexec asks for the password via hyprpolkitagent.
# Used by SUPER+CTRL+K and the power button in the eww bar.
if [ ! -x /usr/local/bin/turn-off-root ]; then
    notify-send -u critical "Turn off" "/usr/local/bin/turn-off-root is not installed (see bin/turn-off-root)"
    exit 1
fi
notify-send "Turn off" "Backing up, the machine powers off when done"
pkexec /usr/local/bin/turn-off-root || notify-send -u critical "Turn off" "Cancelled or backup failed, not powering off"
