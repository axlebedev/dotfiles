local M = {}

-- quickfix next
M.cn = function()
    vim.cmd.cnext()
    vim.fn.timer_start(10, function() vim.cmd('FindCursor #d6d8fa 0') end)
end

-- quickfix prev
M.cp = function()
    vim.cmd.cprev()
    vim.fn.timer_start(10, function() vim.cmd('FindCursor #d6d8fa 0') end)
end

return M
