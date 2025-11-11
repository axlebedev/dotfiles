#!/bin/bash

OPTIONS="$1"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -matching fuzzy -theme ~/.i3/theme.rasi -i -p "Select Tool")

case "$CHOICE" in
  "Gromit-mpx")
    gromit-mpx --active &
    ;;
  "VokoscreenNG")
    $HOME/.i3/runOrKill.sh vokoscreenNG &
    ;;
  "Screenruler")
    nohup screenruler &
    ;;
  "Magnifier")
    nohup xzoom &
    ;;
  *)
    ;;
esac
