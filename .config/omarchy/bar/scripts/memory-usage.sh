#!/bin/bash
read -r total avail <<< "$(awk '
  /^MemTotal:/ { total = $2 }
  /^MemAvailable:/ { avail = $2 }
  END { print total, avail }
' /proc/meminfo)"

used_g=$(awk -v t="$total" -v a="$avail" 'BEGIN { printf "%.1f", (t - a) / 1024 / 1024 }')
total_g=$(awk -v t="$total" 'BEGIN { printf "%.0f", t / 1024 / 1024 }')
pct=$(awk -v t="$total" -v a="$avail" 'BEGIN { printf "%.0f", (t - a) / t * 100 }')

echo "{\"text\": \"󰘚 ${used_g}G/${total_g}G (${pct}%)\", \"tooltip\": \"Memory: ${used_g}G used of ${total_g}G\"}"
