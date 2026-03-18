local plugins = {
    -- auto pairs
    { 'windwp/nvim-autopairs',
      event = 'InsertEnter',

      config = function()
        require('nvim-autopairs').setup({
            check_ts = true,  -- Treesitter integration
            disable_filetype = { 'TelescopePrompt' }
          })

        local Rule = require('nvim-autopairs.rule')

        -- Custom rule to add a space between parentheses/brackets/braces
        require('nvim-autopairs').add_rules({
            Rule(" ", " ")
              :with_pair(function(opts)
                -- Check if the pair under the cursor is (), [], or {}
                  local pair = opts.line:sub(opts.col - 1, opts.col)
                  return vim.tbl_contains({ "()", "[]", "{}" }, pair)
                end),
              })
      end
    },

    -- true/false
    { 'AndrewRadev/switch.vim',
      keys = '<C-s>',
      config = function()
        vim.keymap.set('n', '<C-s>', '<cmd>Switch<CR>')
      end
    },

    -- surround
    { "kylechui/nvim-surround",
      version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      opts = {
        keymaps = {
          visual = "S"
        }
      }
    },

    { 'FooSoft/vim-argwrap' },

    { 'isomoar/vim-css-to-inline' },

    -- autoclose html tag
    { 'windwp/nvim-ts-autotag' },

    { 'numToStr/Comment.nvim',
      opts = {
        toggler = {
          line = "<C-_>",
          block = '<C-_><C-_>',
        },
        opleader = {
          line = '<C-_>',
          block = '<C-_><C-_>',
        },
      }
    },

    -- <C-a> and <C-x> for negative values
    { 'osyo-manga/vim-trip',
      event = "VeryLazy",
      config = function()
        vim.keymap.set('n', '<C-a>', '<Plug>(trip-increment-ignore-minus)')
        vim.keymap.set('n', '<C-x>', '<Plug>(trip-decrement-ignore-minus)')
      end,
    },

    -- textobj
    { 'kana/vim-textobj-entire', dependencies = { 'kana/vim-textobj-user'  } }, -- ae, ie
    { 'kana/vim-textobj-indent', dependencies = { 'kana/vim-textobj-user'  } }, -- ai, ii, aI, iI
    { 'kana/vim-textobj-lastpat', dependencies = { 'kana/vim-textobj-user'  } }, -- last search pattern a/, i/, a?, i?
    { 'kana/vim-textobj-line', dependencies = { 'kana/vim-textobj-user'  } }, -- al, il
    { 'kana/vim-textobj-underscore', dependencies = { 'kana/vim-textobj-user'  } }, -- a_, i_
    { 'Julian/vim-textobj-variable-segment', dependencies = { 'kana/vim-textobj-user'  } }, -- Variable (CamelCase or underscore) segment text object (iv / av).
    { 'rhysd/vim-textobj-anyblock', dependencies = { 'kana/vim-textobj-user'  } },
    { 'glts/vim-textobj-comment', dependencies = { 'kana/vim-textobj-user'  } }, -- comment: ic, ac

    { 'axlebedev/nvim-js-fastlog',
      opts = { js_fastlog_prefix = '11111' },
    },

    { 'axlebedev/yank-filename.nvim',
      cmd = { 'YankFileName', 'YankFileNameForDebug', 'YankGithubURLMaster', 'YankGithubURL' },
    },

    -- dont move cursor to start of yanked text
    { 'svban/YankAssassin.vim', event = 'VeryLazy' },

    -- expand selection
    {
      "terryma/vim-expand-region",
      lazy = false,  -- Load immediately like VimEnter
      keys = {
        { "v",  "<Plug>(expand_region_expand)",  mode = "v", silent = true, nowait = true },
        { "V",  "<Plug>(expand_region_shrink)", mode = "v", silent = true, nowait = true },
        { "<S-v>", "<Plug>(expand_region_shrink)", mode = "v", silent = true, nowait = true },
      },
      config = function()
        vim.fn['expand_region#custom_text_objects']({
            ['a]'] = 1, -- Support nesting of 'around' brackets
            ['ib'] = 1, -- Support nesting of 'around' parentheses
            ['ab'] = 1, -- Support nesting of 'around' parentheses
            ['aB'] = 1, -- Support nesting of 'around' braces
            ['ii'] = 0, -- 'inside indent'. Available through https://github.com/kana/vim-textobj-indent
            ['ai'] = 0, -- 'around indent'. Available through https://github.com/kana/vim-textobj-indent
            ['ia'] = 1,
            ['aa'] = 1,
        })
      end,
    }
}

local init_config = function()
  vim.api.nvim_create_autocmd('TextYankPost', {
      callback = function()
        vim.hl.on_yank({ higroup='IncSearch', timeout=500 })
      end,
    })
end

return {
  plugins = plugins,
  init_config = init_config
}
