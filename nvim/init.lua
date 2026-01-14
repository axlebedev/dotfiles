vim.opt.shell = 'bash'

require("config.lazy")

local dotfiles_path = vim.fn.expand('~') .. '/dotfiles/nvim'
vim.opt.runtimepath:append(dotfiles_path)
