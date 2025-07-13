#!/bin/bash

swayidle -w \
  timeout 900 'hyprlock' \
  timeout 1800 'systemctl suspend' \
  before-sleep 'hyprlock'

