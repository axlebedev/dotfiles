#!/bin/bash

# Check if program name was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <program_name>"
    exit 1
fi

PROGRAM=$1

# Check if program is running
if pgrep -x "$PROGRAM" > /dev/null; then
    pkill -x "$PROGRAM"
    # Wait for processes to terminate
    while pgrep -x "$PROGRAM" > /dev/null; do
        sleep 0.1
    done
else
    exec "$PROGRAM" &
    disown
fi
