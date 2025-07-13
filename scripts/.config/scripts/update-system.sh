#!/bin/bash

sudo pacman -Syu
yay -Syu

pkill -RTMIN+10 waybar
