local M = {}

local maxFoldlevel_cache = {}

local getMaxFoldlevelInCurrentBuffer = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if maxFoldlevel_cache[bufnr] ~= nil then
        return maxFoldlevel_cache[bufnr] 
    end

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
    maxFoldlevel_cache[bufnr] = maxFoldlevel
    return maxFoldlevel
end

M.increaseFoldlevel = function()
    vim.wo.foldmethod = 'syntax'
    local maxFoldlevel = getMaxFoldlevelInCurrentBuffer()
    local new_foldlevel = require('utils.utils').trunc(vim.wo.foldlevel + 1, 0, maxFoldlevel)
    if new_foldlevel ~= vim.wo.foldlevel then
        vim.wo.foldlevel = new_foldlevel
        vim.cmd('redraw')
    end
end

M.decreaseFoldlevel = function()
    vim.wo.foldmethod = 'syntax'
    local maxFoldlevel = getMaxFoldlevelInCurrentBuffer()
    local new_foldlevel = require('utils.utils').trunc(vim.wo.foldlevel - 1, 0, maxFoldlevel - 1)
    if new_foldlevel ~= vim.wo.foldlevel then
        vim.wo.foldlevel = new_foldlevel
        vim.cmd('redraw')
    end
end

return M
