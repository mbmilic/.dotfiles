#!/bin/bash
free=$(df -h --output=avail / | tail -1 | tr -d ' ')
used_pct=$(df -h --output=pcent / | tail -1 | tr -d ' %')
free_pct=$((100 - used_pct))
tooltip=$(df -h / | tail -1 | awk '{print $3 " used, " $4 " free of " $2}')

echo "{\"text\": \"󰋊 ${free} (${free_pct}%)\", \"tooltip\": \"${tooltip}\"}"
