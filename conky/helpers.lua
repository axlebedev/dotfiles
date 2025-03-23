-- vim: ts=2 sw=2 et ai cindent syntax=lua
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

function conky_cpuChar(coreNum)
  local s = conky_parse(string.format('${cpu cpu%d}', coreNum))
  local i = valueToSteps({ value = tonumber(s), rangeMax = 90, stepsMax = #chars - 1 })
  return chars[i]
end

function conky_memoryStr()
  local s = conky_parse('${memperc}')
  local i = valueToSteps({ value = tonumber(s), rangeMax = 90, stepsMax = #chars - 1 })
  return chars[i]
end

-- ###########################################################

beginArrayItem = '${if_match ${\\1 \\2}<TICK}COLOR${else}'
endArrayItem = '${endif}'
function getTemplateForColors(colorsArray, offset)
  offset = offset or 0
  local result = ''

  for i=1,#colorsArray do
    local color = colors[i]
    if (i == #colors) then
      result = result .. color
    else
      local tick = math.floor(100 / #colorsArray * i + offset)
      result = result .. beginArrayItem:gsub('TICK', tick):gsub('COLOR', color)
    end
  end

  for i=1,(#colors - 1) do
    result= result .. endArrayItem
  end

  return result
end

function getCoreTempColor(coreN)
  local beginArrayItem = '${if_match ${cpu cpu' .. coreN .. '}<TICK}COLOR${else}'
  local endArrayItem = '${endif}'

  local result = ''

  for i=1,#colors do
    local color = colors[i]
    if (i == #colors) then
      result = result .. color
    else
      local tick = math.floor(100 / #colors * i)
      result = result .. beginArrayItem:gsub('TICK', tick):gsub('COLOR', color)
    end
  end

  for i=1,(#colors - 1) do
    result= result .. endArrayItem
  end

  return result
end
