#!/bin/bash

entries=" Shutdown\n Reboot\n Suspend \n Standby\n󰭑 Logout\n Lockscreen"

selected=$(echo -e $entries|wofi --dmenu -W 250 -H 250 --location 3 -x -51 -y 6 -k /dev/null | awk '{print tolower($2)}')

case $selected in
  shutdown)
    shutdown;;
  reboot)
    reboot;;
  suspend)
    swaylock & sleep 0.1 && hyprctl dispatch dpms off;;
  logout)
    loginctl terminate-session ${XDG_SESSION_ID-};;
  lockscreen)
    swaylock;;
esac
