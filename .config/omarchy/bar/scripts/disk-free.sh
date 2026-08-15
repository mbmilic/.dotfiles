#!/bin/bash
used=$(df -h --output=used / | tail -1 | tr -d ' ')
total=$(df -h --output=size / | tail -1 | tr -d ' ')
used_pct=$(df -h --output=pcent / | tail -1 | tr -d ' %')
tooltip=$(df -h / | tail -1 | awk '{print $3 " used, " $4 " free of " $2}')

echo "{\"text\": \"󰋊 ${used}/${total} (${used_pct}%)\", \"tooltip\": \"${tooltip}\"}"
