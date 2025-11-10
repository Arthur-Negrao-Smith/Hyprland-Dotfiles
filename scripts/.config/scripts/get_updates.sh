#!/bin/bash

CACHE_FILE="/tmp/updates.state"
CHECKER_PATH="$HOME/.config/scripts/update_checker.sh"

if [[ ! -f "$CACHE_FILE" ]]; then
    echo "{\"text\":\"...\", \"class\":\"low\"}"
else
    cat "$CACHE_FILE"
fi


