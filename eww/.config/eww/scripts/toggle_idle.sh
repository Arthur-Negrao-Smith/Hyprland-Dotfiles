#!/bin/bash

if pgrep -x "hypridle" > /dev/null; then
    pkill hypridle
    notify-send -a "System" "Hypridle" "Inactivity timer DISABLED."
else
    notify-send -a "System" "Hypridle" "Inactivity timer ENABLED."
    hypridle
fi
