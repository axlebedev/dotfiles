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
errorColorFg = '\\#' .. colors[#colors]
errorColorBg = '\\#FFFFFF'

-- textColorFg = '\\#ADCBFF'
textColorFg = '\\#' .. colors[3]
-- secondaryTextColorFg = '\\#8D15EE'
secondaryTextColorFg = '\\#' .. colors[9]

-- TODO color for VPN?

-- config local to machine

internetInterface = 'enp6s0'
hwMonitorPath = '/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input'
