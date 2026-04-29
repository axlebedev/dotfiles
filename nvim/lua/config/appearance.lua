local plugins = {
    -- color scheme
    { "yorik1984/newpaper.nvim",
      priority = 1000,
      config = function()
        require("newpaper").setup({
          style = "light",
          colors = {
            neovim_green = "#376b28",
            redorange = "#376b28",
          },
        })
        vim.cmd.colorscheme("newpaper")
        vim.opt.foldcolumn = "1"
      end,
    },

    -- smooth scroll
    { 'karb94/neoscroll.nvim',
      opts = {
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb', },
      },
    },

    { "axlebedev/find-my-cursor.nvim",
      cmd = 'FindCursor',
      opts = {
        FindCursorHookPre = function()
          -- vim.cmd('FootprintsDisable')
          vim.cmd('IlluminatePause')
        end,
        FindCursorHookPost = function()
          -- vim.cmd('FootprintsEnable')
          vim.cmd('IlluminateResume')
        end,
      },
    },

    -- { dir = "~/github/nvim-footprints",
    --   opts = { footprintsColor = "#D9D9D9" }
    -- },

    { 'RRethy/vim-illuminate',
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require('illuminate').configure({
          providers = {
            'lsp',
            'treesitter',
            'regex'
          },
          delay = 100,
          filetypes_denylist = { 'quickfix', 'fugitive', 'NvimTree' },
        })
      end,
    },

    -- bg color for color strings '#fafafa' and so on
    { "brenoprata10/nvim-highlight-colors",
      config = function()
        require('nvim-highlight-colors').setup({})
      end
    }
}

local init_config = function()
  vim.opt.synmaxcol = 1000

  vim.opt.colorcolumn = "100"

  vim.opt.incsearch = true
  vim.opt.hlsearch = true

  vim.opt.background = 'light'

  vim.opt.termguicolors = true
  vim.defer_fn(function()
    vim.opt.cursorline = true
  end, 100)

  vim.opt.list = true
  vim.opt.listchars = "tab:· ,trail:•,extends:»,precedes:«,conceal:_,nbsp:•"

  vim.opt.showbreak = "»"
end

return {
  plugins = plugins,
  init_config = init_config,
}
