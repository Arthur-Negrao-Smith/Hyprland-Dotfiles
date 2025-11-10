#!/bin/bash

CACHE_FILE="/tmp/updates.state"

sudo pacman -Syu
yay -Syu
flatpak update

echo "{\"text\":\"0\", \"class\":\"zero\"}" > $CACHE_FILE
