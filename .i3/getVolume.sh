# amixer -D pulse sget Master | awk -F'[]%[]' '/%/ {if ($7 == "off") { print "0" } else { print $2 }}'
amixer -D pulse sget Master | tail -1 | sed -r -e 's/.+\[([0-9]+)%.+/\1/'
