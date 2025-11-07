#!/bin/sh

MONITOR=$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .id')

echo "$MONITOR"
