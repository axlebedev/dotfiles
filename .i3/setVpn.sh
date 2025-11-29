#!/bin/bash
HAS_VPN="$(bash ~/dotfiles/.i3/getVPN.sh)"
echo $HAS_VPN
if [ $HAS_VPN = "VPN" ]
then
    # /opt/cisco/secureclient/bin/vpn -s disconnect
    nmcli con down "WB"
else
    nmcli con up "WB"

    # notify-send --expire-time=3000 "Try to VPN. Approve at 'Multifactor' mobile app"
    # printf '\n\NPASSWORD\n' | /opt/cisco/secureclient/bin/vpn -s connect vpn2.ncloudtech.ru
fi
