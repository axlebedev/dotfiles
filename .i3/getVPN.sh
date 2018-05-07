#!/bin/bash
ACTIVE_CON="$(nmcli -f NAME,ACTIVE,TYPE con | grep --perl-regexp "yes\s+vpn")"

if [[ $ACTIVE_CON = "" ]];
then
  return 0
else
  IFS=' ' read -ra NAME <<< "$ACTIVE_CON"
  echo $NAME
fi
