#!/bin/bash
#
# Quickly switch between a given keyboard layout and the US Qwerty one

# 0 - us, 1 - ru
if [ $# -eq 1 ]; then
    TARGET=$1

    if [[ $1 == "en" ]]; then
        gsettings set org.gnome.desktop.input-sources current 1
    else
        gsettings set org.gnome.desktop.input-sources current 0
    fi
else
    CURRENT="$(gsettings get org.gnome.desktop.input-sources current | awk '{ print $2 }')"

    gsettings set org.gnome.desktop.input-sources current $((1 - CURRENT))
fi


