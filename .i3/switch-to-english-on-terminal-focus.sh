#!/bin/bash

doSwitchToEnglishOnTerminalFocus() {
    CLASS=$(echo $1 | jq ".container.window_properties.class")

    if [ $CLASS = "\"Gnome-terminal\"" ]; then
        xkb-switch -s us
    fi
}

i3-msg -t subscribe -m '[ "window" ]' | while read line ; do doSwitchToEnglishOnTerminalFocus $line; done
