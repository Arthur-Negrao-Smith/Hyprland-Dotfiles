#!/bin/bash

CACHE_FILE="/tmp/updates.state"

pacman_updates=$(checkupdates 2>/dev/null | wc -l)
yay_updates=$(yay -Qu 2>/dev/null | wc -l)
total=$((pacman_updates + yay_updates))

# Define cores e texto com base no número de atualizações
if [ "$total" -eq 0 ]; then
    text="0"
    class="zero"
elif [ "$total" -lt 10 ]; then
    text="$total"
    class="low"
    notify-send -a "System" "Updates" "You have updates avaliable: $total"

elif [ "$total" -lt 50 ]; then
    text="$total"
    class="medium"
    notify-send -a "System" "Updates" "You have some updates avaliable: $total"
elif [ "$total" -lt 99 ]; then
    text="$total"
    class="high"
    notify-send -a "System" "Updates" "You have much updates avaliable: $total"
else
    text="+99"
    class="critical"
    notify-send -a "System" "Updates" "You have very much updates avaliable: $total"
fi

echo "{\"text\":\"$text\", \"class\":\"$class\"}" > $CACHE_FILE
