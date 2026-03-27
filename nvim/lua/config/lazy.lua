-- for nvimtree: disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local search = require("config.search")
local appearance = require("config.appearance")
local git = require("config.git")
local lsp = require("config.lsp")
local diagnostic = require("config.diagnostic")
local edit = require("config.edit")
local qf = require("config.qf")
local fold = require("config.fold")

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
    git.plugins,
    search.plugins,
    appearance.plugins,
    edit.plugins,
    lsp.plugins,
    qf.plugins,
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
    {
      "numtostr/BufOnly.nvim",
      config = function()
        vim.keymap.set("n", "bo", "<cmd>BufOnly<CR>")
      end
    },

    {
      "pogyomo/submode.nvim",
      lazy = true,
      config = function()
        local popupUtils = require('utils/popup')
        local group = vim.api.nvim_create_augroup("user-event", {})
        local popupBuf
        local popupWin
        vim.api.nvim_create_autocmd("User", {
            pattern = "SubmodeEnterPost",
            callback = function(env)
              local width = #env.data.name + 4
              _, popupWin = popupUtils.createPopup(
                { '', '  ' .. env.data.name },
                {
                  width = width,
                  height = 3,
                  row = 5,
                  col = math.floor((vim.o.columns - width) / 2),
                })
            end
          })

        vim.api.nvim_create_autocmd("User", {
            group = vim.api.nvim_create_augroup("user-event", {}),
            pattern = "SubmodeLeavePost",
            callback = function(env)
              popupUtils.closePopup(popupWin)
            end
          })
      end
    },
    {
      "smjonas/inc-rename.nvim",
      opts = {},
      config = function()
        require("inc_rename").setup {
          input_buffer_type = "snacks",
        }
    end
    },

    { 'axlebedev/snacks.nvim', -- или notify? это одно и то же
      priority = 1000,
      lazy = false,
      opts = {
        picker = { enabled = true },
        input = { enabled = true },

        notifier = {
          enabled = true,
          timeout = 1500, -- Global default of 1.5s
        },
        styles = {
          notification = {
            relative = "editor",
            row = -2,    -- 2 lines from the bottom
            col = 0.5,   -- 50% from the left (centered)
            anchor = "s", -- Anchor to the "South" (bottom-center)
            width = 0.4, -- Optional: limit width to 40% of screen
          }
        },

        indent = {
          animate = {
            enabled = false,
          },
          indent = {
            enabled = true,
            char = "⁚",
            hl = "SnacksIndentBlank"
          },
          scope = {
            enabled = false, -- enable highlighting the current scope
            priority = 200,
            char = "┊",
            hl = "SnacksIndentScope"
          },
          chunk = {
            enabled = true,
            hl = "SnacksIndentBlank",
            char = {
              corner_top = "╭",
              corner_bottom = "╰",
              horizontal = "─",
              arrow = "─",
            },
          },
        },
      },

      -- TODO: notifier, notify https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md https://github.com/folke/snacks.nvim/blob/main/docs/notify.md

      -- keys = {
      --   { "<c-t>", function() require('snacks').picker() end, desc = "meta picker", mode = { 'n', 'v' } },
      --   { "<leader>t",
      --     function()
      --       require('snacks').picker.smart({
      --         pattern = require('utils/utils').get_visual_selection()
      --       })
      --     end,
      --     desc = "Smart Find Files",
      --     mode = { 'n', 'v' },
      --   },
      --   { "<leader>b", function() require('snacks').picker.buffers() end, desc = "Buffers" },
      --   { "<C-S-p>", function() require('snacks').picker.command_history() end, desc = "Command History" },
      --   { "<C-p>", function() require('snacks').picker.commands() end, desc = "Commands" },
      --   { "<c-q>", function() require('snacks').picker.diagnostics() end, desc = "Diagnostics" },
      --   { "<F1>", function() require('snacks').picker.help() end, desc = "Help Pages" },
      --   { "sft", function()
      --       local filetypes = vim.fn.getcompletion("", "filetype")
      --       vim.ui.select(filetypes, {
      --           prompt = "Set Filetype:",
      --         }, function(choice)
      --           if choice then
      --             vim.bo.filetype = choice
      --           end
      --         end)
      --     end
      --   }
      -- },
    },

    { 'rcarriga/nvim-notify',
      event = "VeryLazy",
      opts = {
        timeout = 2000,
        top_down = false,
        render = 'compact',
      },
    },

    { 'axlebedev/nvim-detect-indent' },

    -- проблема когда делаешь fold submode, после этого buffer write - ставит свой рандомный foldlevel
    -- { 'kevinhwang91/nvim-ufo',
    --   dependencies = 'kevinhwang91/promise-async',
    --   opts = {
    --     open_fold_hl_timeout = 0,
    --     fold_virt_text_handler = require('foldtext').foldtext_fn,
    --     provider_selector = function(bufnr, filetype, buftype)
    --       if filetype == 'magit' then
    --         return ''
    --       end
    --       return {'lsp', 'indent'}  -- Your normal providers
    --     end
    --   },
    -- },
  },

  -- TODO chrisgrieser/nvim-origami
})

edit.init_config()
git.init_config()
appearance.init_config()
lsp.init_config()
diagnostic.init_config()
search.init_config()
qf.init_config()
fold.init_config()
