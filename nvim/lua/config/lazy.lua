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
    { 'sheerun/vim-polyglot' },

    -- Automatically create parent directories on write when don't exist already.
    { 'pbrisbin/vim-mkdir' },

    -- Make '.' work on plugin commands (not all maybe)
    { 'tpope/vim-repeat' }, -- TODO: nnoremap <Plug>(RepeatRedo) U

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

    -- NERDTree
    {
      'nvim-tree/nvim-tree.lua', -- NvimTreeToggle
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('nvim-tree').setup {
          view = { width = 35, side = 'left' },
          filters = { dotfiles = false },  -- Show hidden files (like NERDTree)
          git = { enable = true },
          actions = { open_file = { quit_on_open = false } },
          renderer = {
            icons = { glyphs = { default = '', git = { unstaged = '✗' } } },
            highlight_git = true,
          },
        }

        -- Keymaps (NERDTree-like)
        vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')
        vim.keymap.set('n', '<leader>e', ':NvimTreeFocus<CR>')
      end,
    },

    -- fzf
    {
      'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      }
    },

    -- Markdown
    -- NOTE: need installed 'yarn': 'sudo npm i -g yarn'
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && yarn install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    },

    -- open browser
    {
      'tyru/open-browser.vim',
      keys = {
        { '<F3>', '<Plug>(openbrowser-smart-search)', mode = 'n' },
        { '<F3>', '<Plug>(openbrowser-smart-search)', mode = 'v' },
      },
    },

    -- bufonly
    { 'schickling/vim-bufonly' },

    -- clear hlsearch on cursor move
    {
      'nvimdev/hlsearch.nvim',
      event = 'BufRead',
      config = function()
        require('hlsearch').setup()
      end
    },

    -- color scheme
    {
      'NLKNguyen/papercolor-theme',
      priority = 1000, -- ensures the colorscheme loads first
    },

    -- highlight 'f' character
    {
      "rhysd/clever-f.vim",
      config = function()
        vim.g.clever_f_smart_case = 1
        vim.g.clever_f_across_no_line = 1
        vim.keymap.set("n", ";", "<Plug>(clever-f-repeat-forward)", { noremap = false })
      end,
    },

    -- vim-smoothie
    {
      "karb94/neoscroll.nvim",
      opts = {
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb', },
      },
    }
  },
})

vim.opt.termguicolors = true
vim.opt.background = 'light'
vim.cmd('colorscheme PaperColor')
