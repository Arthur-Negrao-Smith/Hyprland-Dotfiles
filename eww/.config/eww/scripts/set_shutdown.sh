#!/bin/bash

# File to save the state
STATE_FILE="/tmp/shutdown.state"

# Get minutes from the first argument
MINUTES=$1

# Validation: If not a number, do nothing
if ! [[ "$MINUTES" =~ ^[0-9]+$ ]]; then
    notify-send -a "System" "Shutdown Timer" "Invalid input: Please use numbers only."
    exit 1
fi

# If the value is 0, cancel any scheduled shutdown
if [ "$MINUTES" -eq 0 ]; then
    # -c cancels the shutdown
    shutdown -c
    # Remove the state file
    rm -f "$STATE_FILE"
    notify-send -a "System" "Shutdown Timer" "Shutdown canceled."
else
# If greater than 0, schedule the shutdown
    # +MINUTES schedules it for X minutes from now
    shutdown +$MINUTES
    # Create the state file with the message
    echo "Shutting down in ${MINUTES} min." > "$STATE_FILE"
    notify-send -a "System" "Shutdown Timer" "Computer will shut down in ${MINUTES} minutes."
fi
