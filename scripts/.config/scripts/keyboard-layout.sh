#!/bin/bash

keymaps=$(hyprctl devices | grep "active keymap" | awk '{print $4, $5, $6, $7}')

# Search all loyouts by "US"
if echo "$keymaps" | grep -q "US"; then
    echo "Us"
elif echo "$keymaps" | grep -q "Brazil"; then
    echo "Pt-br"
else
    echo "?"
fi
