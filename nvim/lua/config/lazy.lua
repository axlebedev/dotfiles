-- for nvimtree: disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local search = require("config.search")
local lsp = require("config.lsp")
local diagnostic = require("config.diagnostic")
local edit = require("config.edit")
local qf = require("config.qf")

-- Setup lazy.nvim
require('lazy').setup({
  checker = {
    enabled = false,  -- Полностью отключить проверки обновлений
    notify = false,   -- Отключить уведомления (на всякий случай)
  },
  change_detection = {
    notify = false,   -- Отключить уведомления об изменениях конфига
  },
  spec = {
    { import = "config.workspace-widgets" },
    { import = "config.git" },
    search.plugins,
    { import = "config.colors" },
    edit.plugins,
    lsp.plugins,
    { import = "config.treesitter" },

    { 'sheerun/vim-polyglot' },

    -- Automatically create parent directories on write when don't exist already.
    { 'pbrisbin/vim-mkdir' },

    -- Make '.' work on plugin commands (not all maybe)
    { 'tpope/vim-repeat' }, -- TODO: nnoremap <Plug>(RepeatRedo) U

    -- Markdown
    { 'iamcco/markdown-preview.nvim',
      cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
      build = 'cd app && yarn install',
      init = function()
        vim.g.mkdp_filetypes = { 'markdown' }
      end,
      ft = { 'markdown' },
    },

    -- open browser
    { 'tyru/open-browser.vim',
      keys = {
        { '<F3>', '<Plug>(openbrowser-smart-search)', mode = 'n' },
        { '<F3>', '<Plug>(openbrowser-smart-search)', mode = 'v' },
      },
    },

    -- bufonly
    { "numtostr/BufOnly.nvim", cmd = "BufOnly" },

    { "pogyomo/submode.nvim", lazy = true },

    { 'rcarriga/nvim-notify',
      event = "VeryLazy",
      opts = {
        timeout = 2000,
        top_down = false,
        render = 'compact',
        stages = 'fade',
      },
    },

    { 'axlebedev/nvim-detect-indent' },

    { 'kevinhwang91/nvim-ufo',
      dependencies = 'kevinhwang91/promise-async',
      opts = {
        open_fold_hl_timeout = 0,
        fold_virt_text_handler = require('foldtext').foldtext_fn,
        provider_selector = function(bufnr, filetype, buftype)
          if filetype == 'magit' then
            return ''
          end
          return {'lsp', 'indent'}  -- Your normal providers
        end
      },
    },
  },
})

edit.init_config()
lsp.init_config()
diagnostic.init_config()
search.init_config()
qf.init_config()

-- vim.api.nvim_create_autocmd("FileType", {
    --     -- обычно когда открывается quickfix - он залезает под nvimtree
    --     pattern = "qf",
    --     callback = function()
      --       local api = require("nvim-tree.api")
      --       local is_open = api.tree.is_visible()
      --       if (is_open) then
        --         api.tree.focus()
        --         local nt_width = vim.api.nvim_win_get_width(0)
        --         vim.cmd.wincmd("H")
        --         vim.api.nvim_win_set_width(0, nt_width)
        --         vim.cmd.wincmd("p")
      --       end
      --     -- local nt_width = vim.api.nvim_win_get_width(0)
      --     -- vim.cmd("wincmd H")
      --     -- vim.api.nvim_win_set_width(0, nt_width)
      --     -- vim.cmd("wincmd p") -- Jump back to the quickfix window
      --     -- Use pcall to avoid errors if Nvim-Tree isn't open
        --     -- pcall(function()
            --     --   vim.cmd("NvimTreeFocus")
            --     --   local nt_width = vim.api.nvim_win_get_width(0)
            --     --   vim.cmd("wincmd H")
            --     --   vim.api.nvim_win_set_width(0, nt_width)
            --     --   vim.cmd("wincmd p") -- Jump back to the quickfix window
          --     -- end)
      --   end,
    -- })
