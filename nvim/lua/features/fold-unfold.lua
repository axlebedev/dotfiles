local M = {}

local function can_close_fold()
  local lnum = vim.fn.line('.')

  -- 1. Check if the line is NOT already in a closed fold
  local is_not_closed = vim.fn.foldclosed(lnum) == -1

  -- 2. Check if this line is the start of a fold level
  -- A fold starts if its level is higher than the line above it
  local is_start = vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1)

  return is_not_closed and is_start
end

-- If we are at column 0, fold current line;
-- otherwise move left (h).
M.foldOrMoveLeft = function()
  local col = vim.fn.col(".")
  if col == 1 and can_close_fold() then
    vim.cmd('normal! zc')
  else
    vim.cmd('normal! h')
  end
end

-- If cursor is on a folded line, open it recursively;
-- otherwise move to bottom of screen (L).
M.unfoldOrMoveRightRecurs = function()
  local line = vim.fn.line(".")
  if vim.fn.foldclosed(line) ~= -1 then
    vim.cmd('normal! zO')
  else
    vim.cmd('normal! L')
  end
end

M.unfoldOrMoveRight = function()
  local line = vim.fn.line(".")
  if vim.fn.foldclosed(line) ~= -1 then
    vim.cmd('normal! zo')
  else
    vim.cmd('normal! l')
  end
end

return M
