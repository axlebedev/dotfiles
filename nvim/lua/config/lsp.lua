local plugins = {
    { 'neovim/nvim-lspconfig',
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
                bottom = '',
                middle = '',
                vertical = '┊',
              },
              auto_unfold = {
                hovered = false,
              },
            },
            -- Exclude properties/fields (but keep methods and functions)
            symbols = {
              filter = {
                'Property',
                'Field',
                'Variable',
                'Constant',
                exclude = true,  -- exclusive filter: hide these kinds
              },
            },
          })
      end,
    },

    { "axlebedev/codelens.nvim", opts = { sections = { git_authors = nil }} },

    -- format under cursor, or selection
    -- sudo npm i -g eslint_d
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

        vim.keymap.set({ "n", "v" }, "<BS><BS>", function()
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
      opts = { hint_enable = false },
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

  vim.lsp.config('cssls', {
      root_dir = vim.fs.root(args and args.buf or 0, { "package.json", ".git" }) or vim.uv.cwd(),
      filetypes = { "css", "scss", "less" },
      settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
      },
    })

  vim.lsp.config('jsonls', {
      root_dir = vim.fs.root(args and args.buf or 0, { "package.json", ".git" }) or vim.uv.cwd(),
      filetypes = { "json" },
      settings = {
        json = {
          format = { enable = true },
          validate = { enable = true },
        },
      },
    })

  local root_markers1 = {
    '.emmyrc.json',
    '.luarc.json',
    '.luarc.jsonc',
  }
  local root_markers2 = {
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
  }

  vim.lsp.config('lua_ls', {
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers1, root_markers2, { '.git' } }
      or vim.list_extend(vim.list_extend(root_markers1, root_markers2), { '.git' }),
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })

vim.lsp.config('vtsls', {
  cmd = { 'vtsls', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' },
  -- Force the LSP to evaluate from the monorepo root, not the sub-packages
  root_markers = { '.git' },

  handlers = {
    -- Intercept "Go to Definition" using the modern client method
    ['textDocument/definition'] = function(err, result, ctx, config)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not client then return end

      local params = vim.lsp.util.make_position_params()

      -- Modern replacement for execute_command
      client:exec_cmd({
        command = 'typescript.goToSourceDefinition',
        arguments = { params.textDocument.uri, params.position },
      }, { bufnr = ctx.bufnr }, function(cmd_err, cmd_result)
        if not cmd_err and cmd_result and #cmd_result > 0 then
          -- Modern implementation to show the code file
          vim.lsp.util.show_document(cmd_result, client.offset_encoding, { focus = true })
        else
          -- Fallback if no source implementation exists
          vim.lsp.handlers['textDocument/definition'](err, result, ctx, config)
        end
      end)
    end,
  },
  settings = {
    typescript = { preferGoToSourceDefinition = true },
    javascript = { preferGoToSourceDefinition = true },
  },
})

vim.lsp.enable('vtsls')

  -- vim.lsp.config('vtsls', {
  --     on_attach = function(client, bufnr)
  --       -- vim.api.nvim_set_hl(0, "LspSigNormal", { fg = "#24273a", bg = "#cad3f5" })
  --       vim.api.nvim_set_hl(0, "LspSigActive", { fg = "#494d64", bg = "#f2c9cf", bold = true })
  --
  --       require("lsp_signature").on_attach({
  --           bind = true,
  --           handler_opts = {
  --             border = "single",
  --           },
  --           hi_parameter = "LspSigActive",
  --           hint_enable = false,
  --         }, bufnr)
  --     end,
  --     root_dir = vim.fs.root(0, { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }),
  --     settings = {
  --       typescript = {
  --         autoUseWorkspaceTsdk = true,
  --         enableMoveToFileCodeAction = true,
  --         preferGoToSourceDefinition = true, -- я хотел чтобы go to definition вёл в сорц, а он ведёт в .d.ts Этот конфиг ведёт в ещё бОльшую пердь
  --         updateImportsOnFileMove = { enabled = "always" },
  --         inlayHints = {
  --           parameterNames = { enabled = "literals" },
  --           parameterTypes = { enabled = true },
  --           variableTypes = { enabled = true },
  --           propertyDeclarationTypes = { enabled = true },
  --           functionLikeReturnTypes = { enabled = true },
  --           enumMemberValues = { enabled = true },
  --         },
  --
  --         preferences = {
  --           includeCompletionsForModuleExports = true,
  --           includeCompletionsForImportStatements = true,
  --         },
  --         -- This is the key setting
  --         implementCodeActions = {
  --           preferredImplementation = "source"
  --         }
  --       },
  --
  --       javascript = {
  --         preferGoToSourceDefinition = true, -- я хотел чтобы go to definition вёл в сорц, а он ведёт в .d.ts Этот конфиг ведёт в ещё бОльшую пердь
  --         -- Same for JavaScript
  --         implementCodeActions = {
  --           preferredImplementation = "source"
  --         }
  --       },
  --
  --       vtsls = {
  --         settings = { typescript = { preferGoToSourceDefinition = true } },
  --         enableMoveToFileCodeAction = true,
  --         autoUseWorkspaceTsdk = true, -- Use project-specific TS version
  --       },
  --     },
  --
  --     -- cmd = { "vtsls", "--stdio" },
  --     -- reuse_client = function()
  --       --   return true
  --     -- end,
  --   })

-- vim.lsp.config('ts_ls', {
--   cmd = { 'typescript-language-server', '--stdio' },
--   filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' },
--   root_markers = { '.git', 'package.json' },
--   handlers = {
--     ['textDocument/definition'] = function(err, result, ctx, config)
--       local client = vim.lsp.get_client_by_id(ctx.client_id)
--       if not client then return end
--
--       local params = vim.lsp.util.make_position_params()
--
--       -- Note the leading underscore for ts_ls
--       client:request('workspace/executeCommand', {
--         command = '_typescript.goToSourceDefinition',
--         arguments = { params.textDocument.uri, params.position },
--       }, function(cmd_err, cmd_result)
--         if not cmd_err and cmd_result and #cmd_result > 0 then
--           vim.lsp.util.show_document(cmd_result, client.offset_encoding, { focus = true })
--         else
--           vim.lsp.handlers['textDocument/definition'](err, result, ctx, config)
--         end
--       end)
--     end,
--   },
-- })

  -- npm install -g @vtsls/language-server
  -- npm install -g vscode-langservers-extracted (?)
  -- npm install -g @fsouza/prettierd vscode-langservers-extracted
  -- luarocks install lua-language-server
  vim.lsp.enable({
    'vtsls',
    -- 'ts_ls',
    'lua_ls',
    'cssls',
    'jsonls',
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

        local diagnosticWin = nil
        vim.keymap.set("n", "K", function()
          local showHover = function()
            vim.lsp.buf.hover({
                border = "rounded",
                focusable = false,
                relative = "cursor",
                row = 1,  -- Positions above cursor (use vim.api.nvim_win_get_cursor(0)[1] for dynamic)
                col = 20, -- Offset right to avoid "under" cursor overlap
              })
          end

          local showDiagnostic = function()
            return vim.diagnostic.open_float({
                border = "rounded",
                focusable = false,
                relative = "cursor",
                close_events = {
                  "CursorMoved",
                  "CursorMovedI",
                  "BufHidden",
                  "InsertEnter",
                  "TextChanged",
                  "WinLeave",
                },
              })
          end

          if diagnosticWin and vim.api.nvim_buf_is_valid(diagnosticWin) then
            vim.print('if')
            showHover()
            diagnosticWin = nil
          else
            vim.print('else')
            diagnosticWin = showDiagnostic()
            if diagnosticWin == nil then showHover() end
          end
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
end

return {
  plugins = plugins,
  init_config = init_config,
}
