-- vim: ts=2 sw=2 et ai cindent syntax=lua

chars = {
  " ",
  "▁",
  "▂", 
  "▃",
  "▄",
  "▅", 
  "▆",
  "▇",
  "█", 
}


colors = {
  '3A0891',
  '7B75CF',
  'ADCBFF',
  'ADCBFF',
  'ADCBFF',
  'ADCBFF',
  'ADCBFF',
  'AFC5FC',
  'D370D5',
  'F41BAD',
  'FF104F',
}

black = '\\#000000'
white = '\\#FFFFFF'
whitepaper = '\\#EEE7DC'

-- errorColorFg = '\\#C42021'
errorColorFg = '\\#' .. colors[#colors-2]
errorColorBg = '\\#FFFFFF'

-- textColorFg = '\\#ADCBFF'
textColorFg = '\\#' .. colors[3]
-- secondaryTextColorFg = '\\#8D15EE'
secondaryTextColorFg = '\\#' .. colors[9]

-- config local to machine

-- ip addr | awk '/state UP/ {print $2}' | sed 's/.$//'
internetInterface = 'wlp0s20f3'

hwMonitorPath = '/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input'

needNumLockOff = false
needNumLockOn = false
