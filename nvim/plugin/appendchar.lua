-- Append character after last non-whitespace
local function append_char(char)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  local line_num = cursor_pos[1]
  local current_line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]

  -- \v^(.*\S)(\s*)$
  local last_non_ws, trailing_ws = current_line:match('^(.*%S)(%s*)$')
  if last_non_ws then
    local new_text = last_non_ws .. char .. (trailing_ws or '')
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { new_text })
  end

  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)
end

vim.keymap.set('n', '<leader>;', function() append_char(';') end, { silent = true })
vim.keymap.set('n', '<leader>,', function() append_char(',') end, { silent = true })
