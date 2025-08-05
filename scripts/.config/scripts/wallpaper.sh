#!/bin/bash

WALLPAPER_DIR="$HOME/Images/Wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# send a notification
notify-send -a "System" "Your wallpaper was changed to '$WALLPAPER'"

# Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"
