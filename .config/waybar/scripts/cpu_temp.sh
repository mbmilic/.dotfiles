#!/bin/bash
# Find CPU temperature regardless of machine/zone numbering.
# Tries Intel (x86_pkg_temp) then AMD (k10temp/zenpower), falls back to acpitz.
CRITICAL=85

get_temp_from_zone_type() {
    for zone in /sys/class/thermal/thermal_zone*; do
        if [ "$(cat "$zone/type" 2>/dev/null)" = "$1" ]; then
            cat "$zone/temp" 2>/dev/null
            return 0
        fi
    done
    return 1
}

raw=$(get_temp_from_zone_type "x86_pkg_temp" \
    || get_temp_from_zone_type "k10temp" \
    || get_temp_from_zone_type "zenpower" \
    || get_temp_from_zone_type "acpitz" \
    || cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null \
    || echo 0)

temp=$((raw / 1000))

if [ "$temp" -ge "$CRITICAL" ]; then
    echo "{\"text\": \" ${temp}°C\", \"class\": \"critical\"}"
else
    echo "{\"text\": \" ${temp}°C\"}"
fi
