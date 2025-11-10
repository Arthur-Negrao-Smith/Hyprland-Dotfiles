#!/bin/bash

# ---- Configuration ----
WALLPAPER_DIR="$HOME/Images/Wallpapers/"
DEFAULT_WALLPAPER="$WALLPAPER_DIR/default_wallpaper.jpg"
SAVED_STATE="$WALLPAPER_DIR/.saved.state"

# ---- Eww link ----
EWW_SCSS_DIR="$HOME/.config/eww/scss"
PYWAL_LINK_NAME="wal.scss"
PYWAL_LINK_PATH="$EWW_SCSS_DIR/$PYWAL_LINK_NAME"
PYWAL_TARGET_PATH="$HOME/.cache/wal/colors.scss"

# ---- Create state ----
touch "$SAVED_STATE"

# ---- Dunst path ----
DUNST_CONFIG="$HOME/.config/dunst/dunstrc"
DUNST_TEMPLATE="$HOME/.config/dunst/dunstrc.template"

# ---- File names ----
DEFAULT_NAME=$(basename "$DEFAULT_WALLPAPER")
LAST_SAVED_NAME=$(basename "$(cat "$SAVED_STATE")")
STATE_FILE_NAME=$(basename "$SAVED_STATE")

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \
                ! -name "$DEFAULT_NAME" \
                ! -name "$LAST_SAVED_NAME" \
                ! -name "$STATE_FILE_NAME" \
                | shuf -n 1)

# Save state
echo "$WALLPAPER" > "$SAVED_STATE"

# Overwrite the current default wallpaper
cp "$WALLPAPER" "$DEFAULT_WALLPAPER"

# ---- Restart pywal ----
wal -n -s -t -e -i "$DEFAULT_WALLPAPER"

# ---- Load colors ----
source "$HOME/.cache/wal/colors.sh"

# ---- EWW ----
if [ ! -L "$PYWAL_LINK_PATH" ]; then
    notify-send -a "System" "Eww" "Pywal Link don't finded"
    mkdir -p "$EWW_SCSS_DIR"
    # Remove any file
    rm -f "$PYWAL_LINK_PATH"
    # create a symbolic link
    ln -s "$PYWAL_TARGET_PATH" "$PYWAL_LINK_PATH"
fi

# ---- Dunst ----
sed -e "s@__BACK__@$background@g" \
    -e "s@__FORE__@$foreground@g" \
    -e "s@__COLOR1__@$color1@g" \
    -e "s@__COLOR3__@$color3@g" \
    -e "s@__COLOR4__@$color4@g" \
    "$DUNST_TEMPLATE" > "$DUNST_CONFIG"

# ---- Reload apps ----
hyprctl reload
eww reload
killall dunst
dunst &

# ---- Send a notification ----
notify-send -a "System" "Your wallpaper was changed to '$(basename "$WALLPAPER")'"

# ---- Apply the selected wallpaper ----
hyprctl hyprpaper reload ,"$DEFAULT_WALLPAPER"
