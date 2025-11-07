#!/bin/bash

sudo pacman -Syu
yay -Syu
flatpak update

pkill -RTMIN+10 waybar
