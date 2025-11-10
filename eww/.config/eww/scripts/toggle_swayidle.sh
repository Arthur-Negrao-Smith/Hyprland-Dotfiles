#!/bin/bash

if pgrep -x "swayidle" > /dev/null; then
    pkill swayidle
    notify-send -a "System" "Swayidle" "Inactivity timer DISABLED."
else
    swayidle -w
    notify-send -a "System" "Swayidle" "Inactivity timer ENABLED."
fi
