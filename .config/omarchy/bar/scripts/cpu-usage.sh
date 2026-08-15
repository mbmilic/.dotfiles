#!/bin/bash
cpu=$(top -bn1 | awk '/^%?Cpu/ {
  gsub(/,/, "")
  for (i = 1; i <= NF; i++) {
    if ($(i + 1) == "id") {
      printf "%.0f", 100 - $i
      exit
    }
  }
}')

echo "{\"text\": \"󰍛 ${cpu}%\", \"tooltip\": \"CPU ${cpu}%\"}"
