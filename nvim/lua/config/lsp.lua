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
}

local init_config = function()
  -- Enable TypeScript via the Language Server Protocol (LSP)
  vim.lsp.enable('tsserver')
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }
  -- Set the TS config for the LSP
  vim.lsp.config('tsserver', {
      -- Make sure this is on your path
      cmd = {'typescript-language-server', '--stdio'},
      filetypes = { 'javascript', 'typescript', 'typescriptreact', 'javascriptreact' },
      -- This is a hint to tell nvim to find your project root from a file within the tree
      root_dir = vim.fs.root(0, {'package.json', '.git'}),
      capabilities = capabilities,
      settings = {
        diagnostics = { ignoredCodes = { 6133 } }
      }
    })

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

      vim.keymap.set('n', 'ca', vim.lsp.buf.code_action)
      end,
  })

  vim.api.nvim_set_keymap('i', '<Tab>', ' pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true, silent = true })
  vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { expr = true, silent = true })

  vim.keymap.set(
    'n',
    'ff',
    function()
      vim.lsp.buf.code_action({
        context = { only = { 'source.fixAll.eslint' } },
        apply = true
      })
    end,
    { expr = true, silent = true }
  )
end

return {
  plugins = plugins,
  init_config = init_config,
}
