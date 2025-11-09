#!/bin/bash

VALUE=$1
CACHE="/tmp/eww_brightness_last"

MONITOR_1=4
MONITOR_2=5

echo "$VALUE" > "$CACHE"

sleep 0.5

if [[ "$VALUE" == "$(cat $CACHE)" ]]; then
    ddcutil -b $MONITOR_1 setvcp 10 $VALUE
    ddcutil -b $MONITOR_2 setvcp 10 $VALUE
fi
