#!/bin/bash

dbus-monitor "type='signal',interface='org.freedesktop.DisplayManager.Screen.Saver'" | \
while read line; do
    if echo "$line" | grep -q "boolean false"; then
        ./autorandr-change.js
    fi
done
