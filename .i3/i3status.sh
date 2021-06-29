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
    getname=`echo $line | jshon -e name -u`

    if [ "$getname" = "Date" ] 
    then
        google-chrome --app="https://calendar.google.com/" > /dev/null 2>&1 &
    fi

    if [ "$getname" = "Volume" ] 
    then
        google-chrome --user-data-dir="/home/alex/chrome-YTM" --app="https://music.youtube.com/" > /dev/null 2>&1 &
    fi

    if [ "$getname" = "Memory" ] 
    then
        gnome-system-monitor > /dev/null 2>&1 &
    fi

    if [ "$getname" = "Volume" ] 
    then
        gnome-alsamixer > /dev/null 2>&1 &
    fi
done
