local plugins = {
    -- npm install -g vscode-langservers-extracted (?)
    -- npm install -g @fsouza/prettierd vscode-langservers-extracted
    { 'neovim/nvim-lspconfig',
      config = function()
        -- vim.lsp.config(
        --   'lua_ls',
        --   {
        --     on_init = function(client)
        --       client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        --           runtime = {
        --             version = 'LuaJIT',
        --             path = { 'lua/?.lua', 'lua/?/init.lua', },
        --           },
        --           workspace = {
        --             checkThirdParty = false,
        --             library = { vim.env.VIMRUNTIME },
        --           },
        --         })
        --     end,
        --     settings = {
        --       Lua = {},
        --     },
        --   }
        -- )
      end
    },

    { 'esmuellert/nvim-eslint',
      config = function()
        require('nvim-eslint').setup({
            -- settings = {
            --   options = {
            --     ['@stylistic/no-trailing-spaces'] = 0,
            --   },
            -- }
          })
      end,
    },

    { 'hedyhli/outline.nvim',
      lazy = true,
      cmd = { "Outline", "OutlineOpen" },
      keys = { -- Example mapping to toggle outline
        { "<F4>", "<cmd>Outline<CR>", desc = "Toggle outline" },
      },
      config = function()
        require('outline').setup({
          outline_items = {
            show_symbol_lineno = true,
            auto_set_cursor = false,
          },
          guides = {
            enabled = true,
            markers = {
              -- It is recommended for bottom and middle markers to use the same number
              -- of characters to align all child nodes vertically.
              bottom = '',
              middle = '',
              vertical = '┊',
            },
            auto_unfold = {
              hovered = false,
            },
          },
        })
      end,
    },

    { "axlebedev/codelens.nvim", opts = { sections = { git_authors = nil }} },

    -- format under cursor, or selection
    { 'stevearc/conform.nvim',
      opts = {},
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescriptreact = { "eslint_d" },
          },
        })

        vim.keymap.set({ "n", "v" }, "<BS>", function()
          local target_fts = {
            typescript = true,
            typescriptreact = true,
            javascript = true,
            javascriptreact = true
          }

          if target_fts[vim.bo.filetype] then
            -- Run conform for JS/TS files
            require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 500 })
          else
            -- Fallback to built-in indentation
            local mode = vim.api.nvim_get_mode().mode
            local keys = (mode == "v" or mode == "V" or mode == " ") and "=" or "=="
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
          end
        end, { desc = "Format or indent based on filetype" })
      end,
    },

    -- show function signature
    { "ray-x/lsp_signature.nvim",
      event = "VeryLazy",
      opts = {},
      config = function(_, opts) require'lsp_signature'.setup(opts) end
    },
}

local init_config = function()
  -- Enable TypeScript via the Language Server Protocol (LSP)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  vim.lsp.config('vtsls', {
      on_attach = function(client, bufnr)
        require("lsp_signature").on_attach({
          bind = true,
          handler_opts = { border = "rounded" },
          hint_enable = true, -- Show parameter hints at end of line
        }, bufnr)
      end,
      settings = {
        typescript = {
          updateImportsOnFileMove = { enabled = "always" },
          inlayHints = {
            parameterNames = { enabled = "literals" },
            parameterTypes = { enabled = true },
            variableTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            enumMemberValues = { enabled = true },
          },
        },
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true, -- Use project-specific TS version
        },
      },
    })

  -- npm install -g @vtsls/language-server
  vim.lsp.enable('vtsls')

  vim.o.complete = ".,o" -- use buffer and omnifunc
  vim.o.completeopt = "fuzzy,menuone,noselect" -- add 'popup' for docs (sometimes)
  vim.o.autocomplete = true
  vim.o.pumheight = 15

  vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
            -- Optional formating of items
            convert = function(item)
              -- Remove leading misc chars for abbr name,
              -- Only show abbr name, remove leading misc chars (bullets etc.),
              local abbr = item.label
              abbr = abbr:gsub("%b()", ""):gsub("%b{}", "")
              abbr = abbr:match("[%w_.]+.*") or abbr

              local menu = item.detail or ""

              return { abbr = abbr, menu = menu, kind = "" }
            end,
          })

        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover({
              border = "rounded",
              focusable = false,
              relative = "cursor",
              row = 1,  -- Positions above cursor (use vim.api.nvim_win_get_cursor(0)[1] for dynamic)
              col = 20, -- Offset right to avoid "under" cursor overlap
            })
        end, { buffer = ev.buf })

      local isCommandVisible = function(cmd)
        if cmd.kind == 'quickfix' then
          if cmd.command.command == 'eslint.applyDisableLine'
            or cmd.command.command == 'eslint.applyDisableFile'
            or cmd.command.command == 'eslint.openRuleDoc'
          then
            return false
          end
        end

        if cmd.kind == 'refactor.rewrite.export.named'
          or cmd.kind == 'refactor.rewrite.export.default'
          or cmd.kind == 'refactor.rewrite.import.named'
          or cmd.kind == 'refactor.rewrite.import.default'
          or cmd.kind == 'refactor.rewrite.import.namespace'
          or cmd.kind == 'refactor.extract.typedef'
          or cmd.kind == 'refactor.extract.type'
          or cmd.kind == 'refactor.extract.interface'
          or cmd.kind == 'refactor.move.newFile'
          or cmd.kind == 'refactor.rewrite.property.generateAccessors'
          or cmd.kind == 'refactor.rewrite.function.returnType'
        then
          return false
        end

        return true
      end

      vim.keymap.set({ 'n', 'x' }, 'ga', function()
          vim.lsp.buf.code_action({
            filter = isCommandVisible
          })
        end)
      end,
  })

  vim.api.nvim_set_keymap('i', '<Tab>', ' pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true, silent = true })
  vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { expr = true, silent = true })
end

return {
  plugins = plugins,
  init_config = init_config,
}
