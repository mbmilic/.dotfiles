#!/bin/bash
iface=$(ip route show default | awk '/default/ { print $5; exit }')
[ -z "$iface" ] && iface=$(ip -o link show up | awk -F': ' '$2 != "lo" { print $2; exit }')

read -r rx_now tx_now <<< "$(awk -v i="${iface}:" '$1 == i { print $2, $10 }' /proc/net/dev)"
now=$(date +%s.%N)

state_file="$HOME/.cache/omarchy-bar-net.state"
mkdir -p "$(dirname "$state_file")"

if [ -f "$state_file" ]; then
  read -r rx_prev tx_prev t_prev < "$state_file"
else
  rx_prev=$rx_now; tx_prev=$tx_now; t_prev=$now
fi

echo "$rx_now $tx_now $now" > "$state_file"

dt=$(awk -v a="$now" -v b="$t_prev" 'BEGIN { d = a - b; if (d <= 0) d = 1; print d }')
down=$(awk -v a="$rx_now" -v b="$rx_prev" -v dt="$dt" 'BEGIN { d = (a - b) / dt; if (d < 0) d = 0; printf "%.0f", d }')
up=$(awk -v a="$tx_now" -v b="$tx_prev" -v dt="$dt" 'BEGIN { d = (a - b) / dt; if (d < 0) d = 0; printf "%.0f", d }')

human() {
  local bytes=$1
  if [ "$bytes" -ge 1073741824 ]; then
    awk -v b="$bytes" 'BEGIN { printf "%.2fGB", b / 1073741824 }'
  elif [ "$bytes" -ge 1048576 ]; then
    awk -v b="$bytes" 'BEGIN { printf "%.1fMB", b / 1048576 }'
  else
    awk -v b="$bytes" 'BEGIN { printf "%.1fKB", b / 1024 }'
  fi
}

down_h=$(human "$down")
up_h=$(human "$up")

if [ -z "$iface" ]; then
  echo "{\"text\": \"󰖪\", \"tooltip\": \"Disconnected\"}"
else
  if [ -d "/sys/class/net/${iface}/wireless" ]; then
    icon="󰤨"
  else
    icon="󰀂"
  fi
  echo "{\"text\": \"${icon} ↓${down_h}/s ↑${up_h}/s\", \"tooltip\": \"Interface: ${iface}\"}"
fi
