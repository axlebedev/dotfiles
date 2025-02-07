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

internetInterface = 'wlo1'
hwMonitorPath = '/sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input'

needNumLockOff = false
needNumLockOn = true
