#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
PORT=$1
PROC=`sudo lsof -t -i:${PORT}`
sudo kill ${PROC}
