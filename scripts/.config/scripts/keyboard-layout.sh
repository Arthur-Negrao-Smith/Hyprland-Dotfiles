#!/bin/bash

# Método 1: Tenta obter o layout do teclado principal (main: yes)
layout=$(hyprctl devices | grep -A 10 "by-tech-gaming-keyboard" | grep "active keymap" | sed -n '2p' | awk '{print $3, $4}')

# Se não encontrar, Método 2: Pega o primeiro teclado listado
if [ -z "$layout" ]; then
    layout=$(hyprctl devices | grep -A 5 "Keyboard at" | grep "active keymap" | head -n1 | awk '{print $3, $4}')
fi

# Formatação da saída
case "$layout" in
    "Portuguese (Brazil)") echo "Pt-br" ;;
    "English (US)") echo "Us" ;;
    *) echo "??" ;;  # Fallback caso tudo falhe
esac
