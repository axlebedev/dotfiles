#!/bin/sh

echo '{"version":1, "click_events": true }'
echo '[[],'

exec conky -c $HOME/.conkyrc &

# WARNING!!! 'jshon' needed

while read -r line
do
    if [ "$line" = "[" ]
    then
        continue
    fi

    line=`echo $line | sed "s/^,//"`

    # 1 - left, 2 - middle, 3 - right, 4 - wheel up, 5 - wheel down
    button=`echo $line | jshon -e button -u`
    if [ $button != "1" ]
    then
        continue
    fi

    getname=`echo $line | jshon -e name -u`

    if [ "$getname" = "Date" ]
    then
        google-chrome --app="https://mail.myoffice.team/calendar/workweek"> /dev/null 2>&1 &
    fi

    if [ "$getname" = "Memory" ] || [ "$getname" = "CPU" ]  
    then
        gnome-system-monitor > /dev/null 2>&1 &
    fi

    if [ "$getname" = "HDD" ]
    then
        xdg-open ~/Downloads > /dev/null 2>&1 &
    fi

    if [ "$getname" = "Volume" ] 
    then
        pavucontrol --tab=3 --class="floating" > /dev/null 2>&1 &
    fi
    
    if [ "$getname" = "Language" ] 
    then
        setxkbmap -layout us,ru -option 'grp:shift_caps_switch' -option 'kpdl:dot'
        xkb-switch -n
    fi

    if [ "$getname" = "Network" ] 
    then
        ~/dotfiles/.i3/setVpn.sh > /dev/null 2>&1
    fi

    if [ "$getname" = "VirtMon" ] 
    then
        ~/dotfiles/.i3/virtual-monitors.js
    fi
done
