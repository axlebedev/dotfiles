#!/bin/bash

zoom_window=$(xdotool search --name "Zoom Meeting")
xdotool key --window ${zoom_window} alt+a
# bindsym $mod+F5 exec xdotool keydown --window $() alt+a
