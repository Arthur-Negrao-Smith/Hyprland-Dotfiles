#!/bin/bash

# Captura e formata as notificações corretamente
notifications=$(dunstctl history | jq -r '
  .data[][]
  | "\(.appname.data): \(.summary.data) - \(.body.data)"
')

# Verifica se há notificações
if [ -z "$notifications" ]; then
    notify-send -a "System" "No notifications" "The history of Dunst is empty."
    exit 0
fi

# Adiciona opção para limpar histórico
notifications="$notifications"$'\n'"[Clear History]"

# Mostra no rofi
chosen=$(echo "$notifications" | rofi -dmenu -p "Notifications" -lines 10)

# Se escolher limpar histórico
if [ "$chosen" = "[Clear History]" ]; then
    notify-send -a "System" "Notifications" "Hystory is clean."
    dunstctl history-clear
    exit 0
fi

# Reexibe a notificação escolhida
if [ -n "$chosen" ]; then
    notify-send -a "System" "Notifications" "$chosen"
fi
