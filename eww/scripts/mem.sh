#!/bin/bash
# Memory as JSON for eww: {"pct":10,"used":"6.4G","free":"56G","total":"62G"}
# "free" is MemAvailable (what programs can actually use), not MemFree.
awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print t, a}' /proc/meminfo | {
  read -r total avail
  used=$(( total - avail ))
  fmt() { numfmt --to=iec --from-unit=1024 --format="%.1f" "$1" | sed 's/\.0\([KMGT]\)/\1/'; }
  printf '{"pct":%d,"used":"%s","free":"%s","total":"%s"}\n' \
    $(( 100 * used / total )) "$(fmt $used)" "$(fmt $avail)" "$(fmt $total)"
}
