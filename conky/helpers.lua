-- vim: ts=2 sw=2 et ai cindent syntax=lua

function stringWidth(number)
  local result = ""
  for i=1,number do result = result .. '▁' end
  return result
end

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

-- for demo
function demoCpu(i, colorsArray, charsArray) -- assume i=[0..10]
  local n = 10
  local colorIndex = math.floor(i * #colorsArray / n + 0.5)
  local charIndex = math.floor(i * #charsArray / n + 0.5)
  return [[{
    "separator_block_width":3,
    "min_width":"]] .. stringWidth(1) .. [[",
    "full_text" : "]] .. charsArray[charIndex] .. [[",
    "color" : "]] .. colorsArray[colorIndex] .. [[", 
    "separator" : false
  }]]
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

function conky_memoryStr()
  local s = conky_parse('${memperc}')
  return "A" .. s .. "B"
end
