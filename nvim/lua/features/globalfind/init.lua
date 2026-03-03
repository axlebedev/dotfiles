local g = require('features/globalfind/grep')
local f = require('features/globalfind/filtertestentries')
local r = require('features/globalfind/removeqfitem')
local uniqFilesQF = require('features/globalfind/uniqFilesQF')
local resizeQFHeight = require('features/globalfind/resizeQFHeight')

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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf' },
  callback = function()
    vim.keymap.set('n', 'dd', r.RemoveQFItem, { buffer = true, silent = true })
    vim.keymap.set('x', 'd', r.RemoveQFItemsVisual, { buffer = true, silent = true })

    vim.keymap.set('n', '<leader>f', function() r.FilterQF(0) end, { buffer = true })
    vim.keymap.set('x', '<leader>f', function() r.FilterQF(1) end, { buffer = true })

    vim.keymap.set('x', '<leader>rr', resizeQFHeight, { buffer = true })
  end,
})
