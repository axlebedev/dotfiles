#!/bin/bash
HAS_VPN="$(bash ~/dotfiles/.i3/getVPN.sh)"
echo $HAS_VPN
if [ $HAS_VPN = "VPN" ]
then
    /opt/cisco/anyconnect/bin/vpn -s disconnect
else
    notify-send --expire-time=3000 "Try to VPN. Approve at 'Multifactor' mobile app"
    printf '\n\nPASSWORD\n' | /opt/cisco/anyconnect/bin/vpn -s connect vpn2.ncloudtech.ru
fi
