#!/bin/bash

keymaps=$(hyprctl devices | grep "active keymap" | awk '{print $4, $5, $6, $7}')

# Verifica se algum dos layouts ativos contém "(US)"
if echo "$keymaps" | grep -q "(US)"; then
    hyprctl keyword input:kb_layout br,us
    notify-send -a "System" "Your keyboar input was changed: Pt-br"
else
    hyprctl keyword input:kb_layout us,br
    notify-send -a "System" "Your keyboar input was changed: Us"
fi

hyprctl keyword input:kb_options grp:win_space_toggle
