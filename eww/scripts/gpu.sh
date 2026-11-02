#!/bin/bash
# GPU load % (AMD via sysfs; picks the first card that exposes gpu_busy_percent)
for f in /sys/class/drm/card*/device/gpu_busy_percent; do
  [ -r "$f" ] && { cat "$f"; exit 0; }
done
echo 0
