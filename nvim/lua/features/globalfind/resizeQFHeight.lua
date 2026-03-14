local resizeQFHeight = function()
    local qfLength = #vim.fn.getqflist()
    if qfLength == 0 then
        return
    end

    local height = math.min(qfLength + 1, math.floor(vim.o.lines / 2))
    vim.cmd.resize(height)
    vim.cmd('normal! zb')
end

return resizeQFHeight
