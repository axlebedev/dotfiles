-- vim: ts=2 sw=2 et ai cindent syntax=lua

-- 'chars', 'colors'
dofile(os.getenv("HOME") .. '/dotfiles/conky/' .. 'localConfig.lua')

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function valueToSteps(params)
  local value = params.value
  local rangeMin = params.rangeMin or 0
  local rangeMax = params.rangeMax or 100
  local stepsMin = params.stepsMin or 1
  local stepsMax = params.stepsMax or 10

  local p = (value - rangeMin) / (rangeMax - rangeMin)
  local result = math.floor(p * (stepsMax - stepsMin)) + stepsMin
  return clamp(result, stepsMin, stepsMax)
end

function getColor(value)
  local i = valueToSteps({ value = value, stepsMax = #colors, rangeMax = 80 })
  return colors[i]
end


function stringWidth(number)
  local result = ""
  for i=1,number do result = result .. '▁' end
  return result
end

function warningWarning(text)
  return [[{
    "full_text":"]] .. text .. [[",
      "color": "]] .. errorColorBg .. [[",  
      "background": "]] .. errorColorFg .. [[",  
      "align": "center",
      "min_width":"]] .. stringWidth(32) .. [["
  }]]
end

function runShellCmd(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end


function numLock()
  local str = runShellCmd('xset q | grep -o "Num Lock:[[:space:]]*\\(on\\|off\\)"')
  local status = string.match(str, "on|off")

  if needNumLockOff and status == "off" then
    return warningWarning("NumLock off")
  end

  if needNumLockOn and status == "on" then
    return warningWarning("NumLock on")
  end

  return ''
end

function capsLock()
  local str = runShellCmd('xset q | grep -o "Caps Lock:[[:space:]]*\\(on\\|off\\)"')
  local status = string.match(str, "on|off")

  if (status == "on") then
    return warningWarning("CapsLock")
  end

  return ''
end

function getChar(str)
  local s = conky_parse(str)
  local i = valueToSteps({ value = tonumber(s), rangeMax = 90, stepsMax = #chars - 1 })
  return chars[i]
end

function conky_cpuCoreChar(coreNum)
  return getChar(string.format('${cpu cpu%d}', coreNum))
end

function conky_cpuCoreColor(coreNum)
  local s = conky_parse(string.format('${cpu cpu%d}', coreNum))
  return '#' .. getColor(tonumber(s))
end

function conky_memoryStr()
  return getChar('${memperc}')
end

function conky_memory_color()
  local s = tonumber(conky_memoryStr())
  return '#' .. getColor(tonumber(s))
end


function conky_cpuTemperature()
  -- `cat /sys/class/thermal/thermal_zone2/type` should be "x86_pkg_temp"
  local file = io.open("/sys/class/thermal/thermal_zone2/temp", "r")
  if file then
    local temp = file:read("*n") / 1000  -- Convert to degrees Celsius
    file:close()
    return string.format("%.0f", temp)
  else
    return "N/A"
  end
end

function conky_cpuTemperature_color()
  local s = tonumber(conky_cpuTemperature())
  return '#' .. getColor(tonumber(s))
end
