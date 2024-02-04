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

-- errorColorFg = '\\#C42021'
errorColorFg = '\\#' .. colors[#colors-2]
errorColorBg = '\\#FFFFFF'

-- textColorFg = '\\#ADCBFF'
textColorFg = '\\#' .. colors[3]
-- secondaryTextColorFg = '\\#8D15EE'
secondaryTextColorFg = '\\#' .. colors[9]

-- TODO color for VPN?

-- config local to machine

internetInterface = 'wlp3s0'
hwMonitorPath = '/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input'
coresNum = 6

needNumLockOff = false
needNumLockOn = true
