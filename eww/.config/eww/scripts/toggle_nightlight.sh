#!/bin/bash

FIXED_TEMP="4500"

if pgrep -x 'hyprsunset' > /dev/null; then
    pkill hyprsunset
else
    hyprsunset -t $FIXED_TEMP &
fi
