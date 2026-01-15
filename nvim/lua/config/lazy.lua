-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Setup lazy.nvim
require('lazy').setup({
  spec = {
    { 'sheerun/vim-polyglot', lazy = true },

    -- Automatically create parent directories on write when don't exist already.
    { 'pbrisbin/vim-mkdir', lazy = true },

    -- Make '.' work on plugin commands (not all maybe)
    { 'tpope/vim-repeat', lazy = true }, -- TODO: nnoremap <Plug>(RepeatRedo) U

    -- Start screen for vim
    {
      'goolord/alpha-nvim',
      dependencies = { 'nvim-mini/mini.icons' },
      config = function ()
        local startify = require'alpha.themes.startify'
        startify.section.header.val = {}
        startify.config.opts.keymap = { press = 'o' }
        table.insert( startify.section.bottom_buttons.val, startify.button('u', 'Plug update' , '<cmd>Lazy update<CR>'))
        require'alpha'.setup(startify.config)
      end
    },

  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { 'habamax' } },
})

