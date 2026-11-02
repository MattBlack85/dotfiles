#!/bin/bash
# Workspaces as JSON for eww: [{"id":1,"name":"image","active":false}, ...]
ws=$(hyprctl workspaces -j 2>/dev/null) || exit 0
active=$(hyprctl activeworkspace -j 2>/dev/null | jq '.id' 2>/dev/null)
jq -c --argjson a "${active:-0}" \
  'map(select(.id > 0)) | sort_by(.id)
   | map({id, name, active: (.id == $a)})' <<<"$ws" 2>/dev/null
