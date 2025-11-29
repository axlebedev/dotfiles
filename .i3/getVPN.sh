#!/bin/bash
# ACTIVE_CON="$(nmcli -f NAME,ACTIVE,TYPE con | grep --perl-regexp "yes\s+vpn")"
# ACTIVE_CON="$(cat /proc/net/route | grep --perl-regexp "ppp|tun")"
ACTIVE_CON="$(nmcli -c no con show "WB" | grep STATE:)"


if [[ $ACTIVE_CON = "" ]];
then
  echo ""
else
  echo " VPN "
fi
