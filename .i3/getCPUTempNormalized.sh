#!/bin/bash

# map 30 - 70 degrees to 0-100
CPUTEMP=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input | cut -c-2)
echo $(($CPUTEMP * 5 / 2 - 75))
