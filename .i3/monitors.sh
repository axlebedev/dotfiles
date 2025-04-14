#!/bin/bash

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <config> [OUTPUT_PRIMARY] [OUTPUT_LEFT] [OUTPUT_RIGHT]"
    exit 1
fi

# First argument is always OUTPUT_PRIMARY
OUTPUT_PRIMARY=$1

# Override OUTPUT_LEFT if second argument is provided
if [ $# -ge 2 ]; then
    OUTPUT_LEFT=$2
fi

# Override OUTPUT_RIGHT if third argument is provided
if [ $# -ge 3 ]; then
    OUTPUT_RIGHT=$3
fi

# Build xrandr command
XRANDR_CMD="xrandr --auto --output $OUTPUT_PRIMARY --primary"

# Add left output if not 0
if [ "$OUTPUT_LEFT" != "0" ]; then
    XRANDR_CMD="$XRANDR_CMD --auto --output $OUTPUT_LEFT --left-of $OUTPUT_PRIMARY"
fi

# Add right output if not 0
if [ "$OUTPUT_RIGHT" != "0" ]; then
    XRANDR_CMD="$XRANDR_CMD --auto --output $OUTPUT_RIGHT --right-of $OUTPUT_PRIMARY"
fi

# Execute xrandr command
eval $XRANDR_CMD

# Build i3-msg command
I3_MSG_CMD="i3-msg"

# Add workspace commands for left output if not 0
if [ "$OUTPUT_LEFT" != "0" ]; then
    I3_MSG_CMD="$I3_MSG_CMD focus output $OUTPUT_LEFT, workspace 20,"
    I3_MSG_CMD="$I3_MSG_CMD focus output $OUTPUT_LEFT, workspace 10,"
fi

# Add workspace commands for right output if not 0
if [ "$OUTPUT_RIGHT" != "0" ]; then
    I3_MSG_CMD="$I3_MSG_CMD focus output $OUTPUT_RIGHT, workspace 21,"
    I3_MSG_CMD="$I3_MSG_CMD focus output $OUTPUT_RIGHT, workspace 11,"
fi

# Add primary output commands
I3_MSG_CMD="$I3_MSG_CMD focus output $OUTPUT_PRIMARY, workspace 22,"
I3_MSG_CMD="$I3_MSG_CMD focus output $OUTPUT_PRIMARY, workspace 1"

# Execute i3-msg command
eval $I3_MSG_CMD
