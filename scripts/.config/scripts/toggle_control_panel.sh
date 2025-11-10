#!/bin/bash

eww open --toggle control-panel --screen $(hyprctl activewindow -j | jq '.monitor')
