#!/bin/bash

CACHE_FILE="/tmp/updates.state"

PACMAN_COUNT=$(checkupdates 2>/dev/null | wc -l)
YAY_COUNT=$(yay -Qu 2>/dev/null | wc -l)
total=$((PACMAN_COUNT + YAY_COUNT))

TOTAL_INSTALLED_PACKAGES=$(pacman -Q | wc -l)

if [ "$total" -eq 0 ]; then
    text="0"
    class="zero"
elif [ "$total" -lt 10 ]; then
    text="$total"
    class="low"
    MESSAGE="You have updates avaliable: $total"

elif [ "$total" -lt 50 ]; then
    text="$total"
    class="medium"
    MESSAGE="You have some updates avaliable: $total"
elif [ "$total" -lt 99 ]; then
    text="$total"
    class="high"
    MESSAGE="You have much updates avaliable: $total"
else
    text="+99"
    class="critical"
    MESSAGE="You have very much updates avaliable: $total"
fi

if [ "$total" -gt 0 ] && [ -n "$MESSAGE" ]; then
    notify-send -a "System" "Updates" "$MESSAGE" || true
fi

echo "{\"text\":\"$text\", \"class\":\"$class\", \"total_updates\":$total, \"pacman_count\":$PACMAN_COUNT, \"aur_count\":$YAY_COUNT, \"installed_packages\":$TOTAL_INSTALLED_PACKAGES}" > $CACHE_FILE
