#!/bin/bash
# Raw counters for the sysmon bar module (../modules/sysmon.qml).
# Rates and CPU load are computed in QML between samples, so this stays
# stateless and safe to run from one bar per monitor.

iface=$(ip route show default | awk '/default/ { print $5; exit }')
[ -z "$iface" ] && iface=$(ip -o link show up | awk -F': ' '$2 != "lo" { print $2; exit }')

rx=0 tx=0 wireless=false
if [ -n "$iface" ]; then
  # Large counters run straight into the colon ("eth0:123456789"), so split on it first.
  read -r rx tx <<< "$(sed 's/:/ /' /proc/net/dev | awk -v i="$iface" '$1 == i { print $2, $10 }')"
  [ -d "/sys/class/net/${iface}/wireless" ] && wireless=true
fi

read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
cpu_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
cpu_idle=$((idle + iowait))

read -r mem_total mem_avail <<< "$(awk '
  /^MemTotal:/ { total = $2 }
  /^MemAvailable:/ { avail = $2 }
  END { print total, avail }
' /proc/meminfo)"

# Intel (x86_pkg_temp), then AMD (k10temp/zenpower), then acpitz, then zone0.
temp_raw=""
for type in x86_pkg_temp k10temp zenpower acpitz; do
  for zone in /sys/class/thermal/thermal_zone*; do
    if [ "$(cat "$zone/type" 2>/dev/null)" = "$type" ]; then
      temp_raw=$(cat "$zone/temp" 2>/dev/null)
      break 2
    fi
  done
done
[ -z "$temp_raw" ] && temp_raw=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)

printf '{"iface":"%s","wireless":%s,"rx":%s,"tx":%s,"cpuTotal":%s,"cpuIdle":%s,"memTotal":%s,"memAvail":%s,"temp":%s}\n' \
  "$iface" "$wireless" "${rx:-0}" "${tx:-0}" "$cpu_total" "$cpu_idle" \
  "${mem_total:-0}" "${mem_avail:-0}" "$(( ${temp_raw:-0} / 1000 ))"
