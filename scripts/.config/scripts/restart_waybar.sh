#!/bin/bash

if pgrep -x "waybar" > /dev/null
then
    # signal to restart the waybar
    pkill --signal SIGUSR2 waybar
else
    # Inicializa a waybar
    waybar &
fi

notify-send -a "System" "Waybar was restarted"
