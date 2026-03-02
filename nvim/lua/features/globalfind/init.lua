local g = require('features/globalfind/grep')
local f = require('features/globalfind/filtertestentries')

vim.keymap.set('n', '<C-f>', g.Grep)
vim.keymap.set('v', '<C-f>', g.Grep)
vim.keymap.set('n', '<C-f><C-t>', f.filterTestEntries)
