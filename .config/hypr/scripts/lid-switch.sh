#!/bin/bash
# Handles lid close/open without disturbing external monitors.
# Usage: lid-switch.sh close | open

ACTION="$1"

# Get external monitors (all except eDP-1)
EXTERNALS=$(hyprctl monitors -j | python3 -c "
import sys, json
monitors = json.load(sys.stdin)
for m in monitors:
    if m['name'] != 'eDP-1':
        scale = int(m['scale']) if m['scale'] == int(m['scale']) else m['scale']
        print(f\"{m['name']},{m['width']}x{m['height']},0x0,{scale}\")
")

if [ "$ACTION" = "close" ]; then
    # Only disable internal display if an external monitor is connected
    if [ -n "$EXTERNALS" ]; then
        hyprctl keyword monitor "eDP-1,disable"
        # Re-assert external monitor positions so Hyprland doesn't remap them
        while IFS= read -r mon; do
            [ -n "$mon" ] && hyprctl keyword monitor "$mon"
        done <<< "$EXTERNALS"
    fi

elif [ "$ACTION" = "open" ]; then
    # Re-enable internal display
    hyprctl keyword monitor "eDP-1,preferred,0x0,auto"
fi
