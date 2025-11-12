LINE=$(amixer get Master | grep Left:)
VOLUME=$(echo $LINE | awk -F'[][]' '{ print $2+0 }')
MUTED=$(echo $LINE | awk -F'[][]' '{ print $4 }')

if [ $MUTED = "off" ];
then
    echo "Muted"
else
    echo $VOLUME
fi
