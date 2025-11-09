BRIGHTNESS=$(ddcutil -b 4 getvcp 10 | awk -F '[=,]' '{print $2}' | tr -d ' ')

echo $BRIGHTNESS
