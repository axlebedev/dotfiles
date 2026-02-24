local plugins = {
    -- npm install -g vscode-langservers-extracted (?)
    -- npm install -g @fsouza/prettierd vscode-langservers-extracted
    { 'neovim/nvim-lspconfig',
      config = function()
        -- go install github.com/mattn/efm-langserver@latest
        local lang = {
          formatCommand = "eslint_d --stdin --stdin-filename ${INPUT} --fix-to-stdout",
          lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
          lintStylish = true,
          lintFormats = {"%f:%l:%c: %m"}
        }

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
        vim.lsp.config(
          'efm',
          {
            settings = {
              filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
              init_options = { documentFormatting = true },
              settings = {
                rootMarkers = {".git/", "eslint.config.mjs", "package.json"},
                languages = {
                  javascript = lang,
                  typescript = lang,
                  javascriptreact = lang,
                  typescriptreact = lang,
                },
              },
            }
          }
        )
      end
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
      end,
  })

  vim.api.nvim_set_keymap('i', '<Tab>', ' pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true, silent = true })
  vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { expr = true, silent = true })
end

return {
  plugins = plugins,
  init_config = init_config,
}
