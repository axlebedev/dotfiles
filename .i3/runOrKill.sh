#!/bin/bash

# Check if program name was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <program_name>"
    exit 1
fi

PROGRAM=$1
WINDOW_NAME=${2:-$PROGRAM}

# Check if program is running
if pgrep -x "$WINDOW_NAME" > /dev/null; then
    killall $WINDOW_NAME
    # pkill -x "$WINDOW_NAqE"
    # # Wait for processes to terminate
    # while pgrep -x "$WINDOW_NAME" > /dev/null; do
    #     sleep 0.1
    # done
else
    exec "$PROGRAM" &
    disown
fi
