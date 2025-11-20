#!/bin/bash

# Check hardware presence
if ! bluetoothctl --timeout 2 list | grep -q "Controller"; then
    echo "disconnected"
    exit 0
fi

# Check service is on
STATUS=$(systemctl is-active bluetooth.service | tr -d '\n' | tr -d ' ')
if [ "$STATUS" != "active" ]; then
    echo "off"
    exit 0
fi

# Check the adapter status
ADAPTER_STATUS=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
if [ "$ADAPTER_STATUS" == "no" ]; then
    echo "off"
    exit 0
fi

if bluetoothctl --timeout 2 devices Connected | grep -q "Device"; then
    echo "connected"
else
    echo "on"
fi
