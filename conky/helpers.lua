-- vim: ts=2 sw=2 et ai cindent syntax=lua

function stringWidth(number)
  local result = ""
  for i=1,number do result = result .. '▁' end
  return result
end

beginArrayItem = '${if_match ${\\1 \\2}<TICK}COLOR${else}'
endArrayItem = '${endif}'
function getTemplateForColors(colorsArray)
  local result = ''

  for i=1,#colorsArray do
    local color = colors[i]
    if (i == #colors) then
      result = result .. color
    else
      local tick = math.floor(100 / #colorsArray * i)
      result = result .. beginArrayItem:gsub('TICK', tick):gsub('COLOR', color)
    end
  end

  for i=1,(#colors - 1) do
    result= result .. endArrayItem
  end

  return result
end
