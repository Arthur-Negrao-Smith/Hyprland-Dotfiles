#!/bin/bash

CACHE_FILE="/tmp/updates.state"

YELLOW='\e[1;33m'
NC='\e[0m'

echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW}>>> Starting Pacman package update... <<<${NC}"
echo -e "${YELLOW}=========================================${NC}"
sudo pacman -Syu

echo -e "\n${YELLOW}============================================${NC}"
echo -e "${YELLOW}>>> Starting AUR package update (yay)... <<<${NC}"
echo -e "${YELLOW}============================================${NC}"
yay -Syu

echo -e "\n${YELLOW}==========================================${NC}"
echo -e "${YELLOW}>>> Starting Flatpak package update... <<<${NC}"
echo -e "${YELLOW}==========================================${NC}"
flatpak update

TOTAL_INSTALLED_PACKAGES=$(pacman -Q | wc -l)

echo "{\"text\":\"0\", \"class\":\"zero\", \"total_updates\":0, \"pacman_count\":0, \"aur_count\":0, \"installed_packages\":$TOTAL_INSTALLED_PACKAGES}" > $CACHE_FILE
