#!/bin/sh

BLANK='#00000000'
CLEAR='#ffffff22'
DEFAULT='#ff00ffcc'
TEXT='#7B75CFEE'
WRONG='#880000bb'
VERIFYING='#bb00bbbb'

i3lock \
     --no-verify \
        --ignore-empty-password \
        --blur=5 \
        --radius=140 \
        --ring-width=10 \
        --line-uses-inside \
        --inside-color=7B75CF33 \
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
--time-str="%H:%M:%S"        \
--date-str="%A, %Y-%m-%d"       \
--keylayout 1                \
