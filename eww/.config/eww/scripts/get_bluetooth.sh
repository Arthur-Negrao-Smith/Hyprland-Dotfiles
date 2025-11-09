#!/bin/bash

# Check hardware presence
if ! bluetoothctl --timeout 2 list | grep -q "Controller"; then
    echo "disconnected"
    exit 0
fi

# Check service is on
if ! systemctl is-active --quiet bluetooth.service; then
    echo "off"
    exit 0
fi

if bluetoothctl --timeout 2 devices Connected | grep -q "Device"; then
    echo "connected"
else
    echo "on"
fi
