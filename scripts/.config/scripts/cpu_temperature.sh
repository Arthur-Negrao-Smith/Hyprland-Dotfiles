#!/bin/bash

temp=$(sensors | awk '/Tctl/ {print $2}' | sed 's/+//; s/°C//')

if [[ $(echo "$temp < 50" | tr -d '.' | awk '{print ($1 < 5000)}') -eq 1 ]]; then
    class="low"
elif [[ $(echo "$temp < 80" | tr -d '.' | awk '{print ($1 < 8000)}') -eq 1 ]]; then
    class="medium"
else
    class="high"
fi

echo "{\"text\": \"$temp\", \"class\": \"$class\"}"
