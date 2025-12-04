#!/bin/bash

doSwitchToEnglishOnTerminalFocus() {
    CLASS=$(echo $1 | jq -r ".container.window_properties.class" 2>/dev/null || echo "")

    if [ "$CLASS" = "Gnome-terminal" ] || [ "$CLASS" = "kitty" ]; then
        gsettings set org.gnome.desktop.input-sources current 0
        # строка выше - то же самое что xkb-switch -s us
    fi
}

i3-msg -t subscribe -m '[ "window" ]' | while read -r line ; do 
    doSwitchToEnglishOnTerminalFocus "$line"; 
done

