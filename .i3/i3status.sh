#!/bin/sh

echo '{"version":1, "click_events": true }'
echo '[[],'

exec conky -c $HOME/.conkyrc &

# WARNING!!! 'jshon' needed

CAL_PID=0

while read -r line
do
    if [ "$line" = "[" ]
    then
        continue
    fi

    line=`echo $line | sed "s/^,//"`
    getname=`echo $line | jshon -e name -u`

    if [ "$getname" = "Date" ] 
    then
        if [ $CAL_PID -eq 0 ] 
        then
            gsimplecal &
            CAL_PID=$!
        else
            kill $CAL_PID
            CAL_PID=0
        fi
    fi

    if [ "$getname" = "Memory" ] 
    then
        gnome-system-monitor
    fi

    if [ "$getname" = "Volume" ] 
    then
        gnome-alsamixer
    fi
done
