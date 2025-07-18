#!/bin/bash

keymaps=$(hyprctl devices | grep "active keymap" | awk '{print $4, $5, $6, $7}')

# Verifica se algum dos layouts ativos contém "(US)"
if echo "$keymaps" | grep -q "(US)"; then
    echo "Us"
else
    echo "Pt-br"
fi
