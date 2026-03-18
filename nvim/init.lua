vim.opt.shell = 'bash'

local dotfiles_path = vim.fn.expand('~') .. '/dotfiles/nvim'
vim.opt.runtimepath:append(dotfiles_path)

require("config/initlazy").init_lazy()

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.opt.mousemoveevent = true

require("config/lazy")

require("features/globalfind")
require("features/appendchar")
require("features/foldlevel")
require("features/opennextbuf")
require("features/updatebuffer")
require("features/calc-virtual-text")
require("features/refactor")
