vim.opt.shell = 'bash'

local dotfiles_path = vim.fn.expand('~') .. '/dotfiles/nvim'
vim.opt.runtimepath:append(dotfiles_path)

require("config.lazy")
