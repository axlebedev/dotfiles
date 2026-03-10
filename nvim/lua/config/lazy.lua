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
        -- vim.keymap.set("n", "<leader>rn", function()
        --   return ":IncRename " .. vim.fn.expand("<cword>")
        -- end, { expr = true })
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
          },
          char = "┊",
          scope = {
            enabled = false, -- enable highlighting the current scope
            priority = 200,
            char = "┊",
            hl = "SnacksIndentScope"
          },
          chunk = {
            enabled = true,
            hl = "SnacksIndentChunk",
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
        -- { "<leader>t", function Snacks.picker() end, desc = "meta picker" }, -- GREAT GREAT
      --   -- Top Pickers & Explorer
      --   { "<leader><space>r", function() Snacks.picker.smart() end, desc = "Smart Find Files" }, -- GREAT
      --   { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" }, -- GREAT
      --   -- { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      --   { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" }, -- GREAT
      --   -- { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      --   -- { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      --   -- search
      --   { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      --   { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      --   { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" }, -- GREAT
      --   { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      --   { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" }, -- GREAT
      --   { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" }, -- GREAT
      --   { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      --   { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      --   { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" }, -- GREAT интересное
      --   { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      --   { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      --   { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      --   { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      --   { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      --   { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      --   { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      --   { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      --   -- LSP
      --   { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      --   { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      --   { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      --   { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      --   { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      --   { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      --   { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
      --   { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      --   { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
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
