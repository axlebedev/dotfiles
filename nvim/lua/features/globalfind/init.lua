local g = require('features/globalfind/grep')
local f = require('features/globalfind/filtertestentries')
local uniqFilesQF = require('features/globalfind/uniqFilesQF')

-- quickfix next
local cn = function()
    local ok, err = pcall(vim.cmd, "cnext")
    if not ok then
        vim.cmd.cfirst()
    end
    vim.fn.timer_start(10, function() vim.cmd('FindCursor #d6d8fa 0') end)
end

-- quickfix prev
local cp = function()
    local ok, err = pcall(vim.cmd, "cprev")
    if not ok then
        vim.cmd.clast()
    end
    vim.fn.timer_start(10, function() vim.cmd('FindCursor #d6d8fa 0') end)
end

vim.keymap.set('n', '<C-f>', g.Grep)
vim.keymap.set('v', '<C-f>', g.Grep)
vim.keymap.set('n', '<C-f><C-t>', f.filterTestEntries)
vim.keymap.set('n', '<C-f><C-d>', uniqFilesQF, { silent = true })
vim.keymap.set('n', 'cn', cn, { silent = true })
vim.keymap.set('n', 'cp', cp, { silent = true })

