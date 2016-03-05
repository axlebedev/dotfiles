#!/bin/sh

echo '{"version":1, "click_events": true }'
echo '['
echo '[],'

exec conky -c $HOME/.conkyrc &

CAL_PID=0
NAME="Date"

while read -r line
do
    if [ "$line" = "[" ]
    then
        continue
    fi
    line=`echo $line | sed "s/^,//"`
    getname=`echo $line | jshon -e name -u`
    if [ "$getname" = "$NAME" ] 
    then
        if [[ $CAL_PID -eq 0 ]] 
        then
            gsimplecal &
            CAL_PID=$!
        else
            kill $CAL_PID
            CAL_PID=0
        fi
    fi
done
