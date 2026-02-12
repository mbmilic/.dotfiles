#!/usr/bin/env bash
export DEVICE="cirq1080:00-0488:1054-touchpad"
export STATUS_FILE="/tmp/touchpad.status"

enable_touchpad() {
    hyprctl keyword "device[$DEVICE]enabled" true
    printf "true" > "$STATUS_FILE"
    notify-send "Touchpad Enabled"
}

disable_touchpad() {
    hyprctl -r keyword "device[$DEVICE]enabled" false
    printf "false" > "$STATUS_FILE"
    notify-send "Touchpad Disabled"
}

if [ ! -f "$STATUS_FILE" ] || [ "$(cat "$STATUS_FILE")" = "true" ]; then
    disable_touchpad
else
    enable_touchpad
fi   
