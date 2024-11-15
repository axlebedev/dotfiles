#!/bin/bash

# home desktop
OUTPUT_PRIMARY=HDMI-0
OUTPUT_LEFT=DVI-D-0
OUTPUT_RIGHT=DP-4

# home NERPA
if [[ $1 == "nerpa-home" ]]; then
    OUTPUT_PRIMARY=HDMI-1
    OUTPUT_LEFT=eDP-1
    OUTPUT_RIGHT=DP-1
fi

# office
if [[ $1 == "nerpa-office" ]]; then
    OUTPUT_PRIMARY=DP-1
    OUTPUT_LEFT=eDP-1
    OUTPUT_RIGHT=HDMI-1
fi

# single
if [[ $1 == "nerpa-single" ]]; then
    OUTPUT_PRIMARY=eDP-1
    OUTPUT_LEFT=0
    OUTPUT_RIGHT=0
fi

xrandr \
  --auto --output $OUTPUT_PRIMARY --primary \
  --auto --output $OUTPUT_LEFT --left-of $OUTPUT_PRIMARY \
  --auto --output $OUTPUT_RIGHT --right-of $OUTPUT_PRIMARY

i3-msg \
    focus output $OUTPUT_LEFT, workspace 20, \
    focus output $OUTPUT_RIGHT, workspace 21, \
    focus output $OUTPUT_PRIMARY, workspace 22, \
    focus output $OUTPUT_LEFT, workspace 10, \
    focus output $OUTPUT_RIGHT, workspace 11, \
    focus output $OUTPUT_PRIMARY, workspace 1
