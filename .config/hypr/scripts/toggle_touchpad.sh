#!/usr/bin/env bash
# Toggle the touchpad. Uses Omarchy's own tool, which finds the touchpad by
# itself, works with Hyprland's Lua config (hyprctl keyword no longer does),
# and keeps the state across config reloads.
exec omarchy-toggle-input-device touchpad toggle
