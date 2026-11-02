#!/bin/bash
# Workspace names sorted by id, active one in brackets: "graphics [web] emacs ..."
ws=$(hyprctl workspaces -j 2>/dev/null) || exit 0
active=$(hyprctl activeworkspace -j 2>/dev/null | jq '.id' 2>/dev/null)
jq -r --argjson a "${active:-0}" \
  'map(select(.id >= 1 and .id <= 8)) | sort_by(.id)
   | map(if .id == $a then "[\(.name)]" else .name end) | join(" ")' <<<"$ws" 2>/dev/null
