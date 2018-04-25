#!/bin/bash

setxkbmap -layout us,ru -option grp:shift_caps_switch
xrandr --output HDMI1 --auto --above LVDS1
