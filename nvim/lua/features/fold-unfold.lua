local M = {}

-- If we are at column 0, fold current line;
-- otherwise move left (h).
M.foldOrMoveLeft = function()
  local col = vim.fn.col(".")
  if col == 1 then
    vim.cmd('normal! zc')
  else
    vim.cmd('normal! h')
  end
end

-- If cursor is on a folded line, open it recursively;
-- otherwise move to bottom of screen (L).
M.unfoldOrMoveRight = function()
  local line = vim.fn.line(".")
  if vim.fn.foldclosed(line) ~= -1 then
    vim.cmd('normal! zO')
  else
    vim.cmd('normal! L')
  end
end

return M
