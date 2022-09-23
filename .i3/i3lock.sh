#!/bin/bash

BLANK='#00000000'
CLEAR='#ffffff22'
DEFAULT='#ff00ffcc'
TEXT='#7B75CFEE'
WRONG='#880000bb'
VERIFYING='#bb00bbbb'
# echo 'starting' >> /home/l-e-b-e-d-e-v/dotfiles/log
# echo $(date +"%T") >> /home/l-e-b-e-d-e-v/dotfiles/log
notify-send DUNST_COMMAND_PAUSE
i3lock \
        --nofork \
        --ignore-empty-password \
        --blur=10 \
        --radius=140 \
        --ring-width=10 \
        --line-uses-inside \
        --inside-color=$BLANK \
        --ring-color=$BLANK \
        --insidever-color=ADCBFF88  \
        --ringver-color=$BLANK \
        --insidewrong-color=F41BAD88  \
        --ringwrong-color=$BLANK \
        --keyhl-color=7B75CFAA \
        --bshl-color=F41BADAA \
        --separator-color=$BLANK \
\
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
\
--screen 1                   \
--clock                      \
--indicator                  \
--time-str="%H:%M"        \
--date-str=""       \
--keylayout 1 && notify-send DUNST_COMMAND_RESUME
# --keylayout 1 && echo 'waited' >> /home/l-e-b-e-d-e-v/dotfiles/log && echo $(date +"%T") >> /home/l-e-b-e-d-e-v/dotfiles/log && (sleep 1 && notify-send DUNST_COMMAND_RESUME)
