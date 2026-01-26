local M = {}

M.get_visual_selection = function()
  -- Get the current mode
  local mode = vim.api.nvim_get_mode().mode

  -- Check if in a visual mode (character, line, or block)
  if mode:match("^v") or mode:match("^V") or mode:match("\22") then
    -- 'v' gives the start of the selection, '.' gives the current cursor position (end of selection)
    -- The type parameter is crucial for correct block-wise selection handling
    local selection_table = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })

    -- getregion() returns a list of lines, so we concatenate them with a newline
    return table.concat(selection_table, "\n")
  else
    return "" -- Or handle the case where no visual selection is active
  end
end

M.empty = function(s)
  return s == mil or s == ''
end

return M
