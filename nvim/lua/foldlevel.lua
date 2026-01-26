local M = {}

local getMaxFoldlevelInCurrentBuffer = function()
    vim.wo.foldmethod = 'syntax'
    local maxFoldlevel = 1
    local currentLine = 1
    local maxline = vim.fn.line("$")
    while currentLine <= maxline do
        local currentLineFoldlevel = vim.fn.foldlevel(currentLine)
        if currentLineFoldlevel > maxFoldlevel then
            maxFoldlevel = currentLineFoldlevel
        end
        currentLine = currentLine + 1
    end
    return maxFoldlevel
end

M.increaseFoldlevel = function()
    vim.wo.foldmethod = 'syntax'
    vim.wo.foldlevel = vim.wo.foldlevel + 1
end

M.decreaseFoldlevel = function()
    vim.wo.foldmethod = 'syntax'
    local maxFoldlevel = getMaxFoldlevelInCurrentBuffer()
    vim.wo.foldlevel = vim.wo.foldlevel - 1 >= maxFoldlevel 
        and maxFoldlevel - 1 
        or vim.wo.foldlevel - 1
end

return M
