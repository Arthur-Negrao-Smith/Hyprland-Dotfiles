#!/bin/bash

#    'head -n 1' get the first active connection
TYPE=$(nmcli -t -f TYPE,STATE device | grep ':connected' | awk -F: '{print $1}' | head -n 1)

if [ "$TYPE" = "wifi" ]; then
    echo "wifi"
elif [ "$TYPE" = "ethernet" ]; then
    echo "ethernet"
else
    # If don't have wifi or ethernet
    STATE=$(nmcli general status | awk 'FNR == 2 {print $1}')

    case "$STATE" in
        "unavailable")
            # Hardware off
            echo "offline"
            ;;
        "disconnected" | "connecting" | "disconnecting")
            # Hardware on
            echo "disconnected"
            ;;
        *)
            # Other state ('unmanaged')
            echo "disconnected"
            ;;
    esac
fi
