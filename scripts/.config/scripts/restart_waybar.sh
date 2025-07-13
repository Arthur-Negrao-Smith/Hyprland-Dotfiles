#!/bin/bash

if pgrep -x "waybar" > /dev/null
then
    # Mata o processo da waybar
    pkill waybar
    # Espera um pouco para garantir que o processo foi terminado
    sleep 0.5
    # Inicializa novamente a waybar
    waybar &
else
    # Inicializa a waybar
    waybar &
fi

notify-send -a "System" "Waybar was restarted"
