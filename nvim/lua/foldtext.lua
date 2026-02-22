local M = {}

M.foldtext_fn = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' %d↘ '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, {chunkText, hlGroup})
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      break
    end
    curWidth = curWidth + chunkWidth
  end

  local croppedWidth = 0
  while croppedWidth < sufWidth do
    local remainingWidth = sufWidth - croppedWidth
    local text = newVirtText[1][1]
    local textWidth =  vim.fn.strdisplaywidth(text)
    if textWidth < remainingWidth then
      table.remove(newVirtText, 1)
    else
      newVirtText[1][1] = string.sub(text, sufWidth - croppedWidth + 1)
    end
    croppedWidth = croppedWidth + textWidth
  end
  table.insert(newVirtText, 1, {suffix, 'MoreMsg'})
  return newVirtText
end

return M
