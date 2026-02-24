return {
    -- color scheme
    { "yorik1984/newpaper.nvim",
      priority = 1000,
      config = function()
        require("newpaper").setup({ style = "light" })
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
          vim.cmd('FootprintsDisable')
          vim.cmd('IlluminatePause')
        end,
        FindCursorHookPost = function()
          vim.cmd('FootprintsEnable')
          vim.cmd('IlluminateResume')
        end,
      },
    },

    { dir = "~/github/nvim-footprints",
      opts = { footprintsColor = "#D9D9D9" }
    },

    { 'RRethy/vim-illuminate',
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require('illuminate').configure({
          providers = { 'lsp', 'treesitter', 'regex' },
          delay = 100,
          filetypes_denylist = { 'quickfix', 'fugitive' },
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
