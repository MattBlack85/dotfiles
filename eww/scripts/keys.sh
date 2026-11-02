#!/bin/bash
# Keybinds for the eww popup, read live from Hyprland (descriptions come from hypr/binds.lua).
# Output: {"left":[{"section":"Programs","items":[{"keys":"SUPER + P / D","text":"App launcher"}]}], "right":[...]}
hyprctl binds -j 2>/dev/null | jq -c '
  def bit($m; $n): (($m / $n | floor) % 2) == 1;
  def mods($m): [ (if bit($m; 64) then "SUPER" else empty end),
                  (if bit($m; 4)  then "CTRL"  else empty end),
                  (if bit($m; 8)  then "ALT"   else empty end),
                  (if bit($m; 1)  then "SHIFT" else empty end) ];
  def pretty: if . == "period" then "." elif . == "comma" then "," elif . == "space" then "SPACE"
              elif . == "Return" then "ENTER" else ascii_upcase end;

  [ .[] | select(.has_description) | (.description | split("::")) as $p
    | { section: $p[0],
        keys: ((mods(.modmask) + [ (if $p[1] != "" then $p[1] else (.key | pretty) end) ]) | join(" + ")),
        text: $p[2] } ]
  # group by section, keeping the order they were declared in
  | reduce .[] as $b ([]; (map(.section) | index($b.section)) as $i
        | if $i == null then . + [{section: $b.section, items: [$b | {keys, text}]}]
          else .[$i].items += [$b | {keys, text}] end)
  # split into two columns of roughly equal height
  | (map(.items | length + 2) | add) as $total
  | reduce .[] as $s ({left: [], right: [], n: 0};
        if .n < ($total / 2) then .left += [$s] | .n += ($s.items | length + 2)
        else .right += [$s] end)
  | del(.n)'
