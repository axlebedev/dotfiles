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
        google-chrome --app="https://calendar.google.com/" > /dev/null 2>&1 &
    fi

    if [ "$getname" = "Volume" ] 
    then
        amixer -D pulse sset Master toggle > /dev/null 2>&1 & killall -USR1 i3status > /dev/null 2>&1
    fi

    if [ "$getname" = "Memory" ] || [ "$getname" = "CPU" ]  
    then
        gnome-system-monitor > /dev/null 2>&1 &
    fi

    if [ "$getname" = "HDD" ]
    then
        nautilus --class="floating" > /dev/null 2>&1 &
    fi

    if [ "$getname" = "Volume" ] 
    then
        gnome-alsamixer > /dev/null 2>&1 &
    fi
    
    if [ "$getname" = "Language" ] 
    then
        xkb-switch -n
    fi
done
