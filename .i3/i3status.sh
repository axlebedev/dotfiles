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

    # How to avoid 'restore tabs' popup
    # https://forum.uipath.com/t/how-to-close-restore-pages-pop-up-in-chrome/213168/2
    if [ "$getname" = "Volume" ] 
    then
        sed -i "s/\"exited_cleanly\":false/\"exited_cleanly\":true/g" /home/alex/chrome-YTM/Local\ State
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
    
    if [ "$getname" = "Language" ] 
    then
        xkb-switch -n
    fi
done
