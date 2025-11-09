#!/bin/bash

STEP=10
ACTION=$1

MONITOR_1=4
MONITOR_2=5

case $ACTION in
    up)
        ddcutil -b $MONITOR_1 setvcp 10 + $STEP
        ddcutil -b $MONITOR_2 setvcp 10 + $STEP
    ;;
    down)
        ddcutil -b $MONITOR_1 setvcp 10 - $STEP
        ddcutil -b $MONITOR_2 setvcp 10 - $STEP
    ;;
esac

brightness=$(ddcutil -b $MONITOR_1 getvcp 10 | awk -F '[=,]' '{print $2}' | tr -d ' ')
notify-send -a "System" "The monitor brightness is $brightness%"
