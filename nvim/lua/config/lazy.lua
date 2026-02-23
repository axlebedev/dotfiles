-- for nvimtree: disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
    -- { import = "plugins" }, -- TODO

    { 'sheerun/vim-polyglot' },

    -- sudo apt install tree-sitter-cli tar curl
    { 'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate',
      config = function()
        require("nvim-treesitter").setup({
          ensure_installed = { 'javascript', 'awk', 'bash', 'c', 'cmake', 'cpp', 'css', 'csv', 'diff', 'dockerfile',
            'fish', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'go', 'html', 'http', 'ini', 'jq', 'jsdoc',
            'json', 'json5', 'jsx', 'lua', 'make', 'markdown', 'markdown_inline', 'printf', 'regex', 'scss', 'typescript', 'vim',
          'vimdoc', 'vue', 'yaml' },
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          },
          indent = { enable = true },
          textobjects = { enable = true },
        })
      end
    },

    { "MeanderingProgrammer/treesitter-modules.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      opts = {
        incremental_selection = {
          enable = true,
          disable = false,
          keymaps = {
            init_selection = false,
            node_incremental = "v",
            scope_incremental = false,
            node_decremental = "V",
          },
        },
      },
    },

    -- Automatically create parent directories on write when don't exist already.
    { 'pbrisbin/vim-mkdir' },

    -- Make '.' work on plugin commands (not all maybe)
    { 'tpope/vim-repeat' }, -- TODO: nnoremap <Plug>(RepeatRedo) U

    { 'axlebedev/vim-startify',
      config = function()
        vim.g.startify_lists = {
          { type = 'dir',      header = { '   MRU ' .. vim.fn.getcwd() } },
          { type = 'sessions', header = { '   Sessions' } },
          { type = 'commands', header = { '   Commands' } },
        }

        vim.g.startify_commands = { ':Lazy update', ':TSUpdate' }
        vim.g.startify_files_number = 10
        vim.g.startify_update_oldfiles = 1
        vim.g.startify_change_to_dir = 0
        vim.g.startify_custom_header = {}

        -- Remap 'o' to open file in Startify window
        vim.api.nvim_create_autocmd('User', {
          pattern = 'Startified',
          callback = function()
            vim.keymap.set('n', 'o', '<plug>(startify-open-buffers)', { buffer = true })
          end,
        })
      end,
    },

    -- NERDTree
    { 'nvim-tree/nvim-tree.lua',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('nvim-tree').setup {
          view = {
            width = 35,
            side = 'left',
            number = false,
            relativenumber = false,
            adaptive_size = false,
          },
          filters = {
            dotfiles = false, -- Show hidden files (like NERDTree)
            custom = { "^node_modules$" }, -- Exclude node_modules
          },
          git = { enable = true, ignore = false },
          actions = { open_file = { quit_on_open = false } },
          renderer = {
            icons = { glyphs = { default = '', git = { unstaged = '✗' } } },
            highlight_git = true,
          },
        }

        vim.defer_fn(function()
          require("nvim-tree.api").tree.toggle({ focus = false })
        end, 10)
      end,
    },

    -- fzf
    { 'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
      config = function()
        local actions = require("telescope.actions")

        require('telescope').setup{
          defaults = {
            preview = false,
            mappings = {
              i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
              },
              n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
              },
            },
          },
          pickers = {},
          extensions = {},
        }
      end
    },

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

    -- clear hlsearch on cursor move
    { 'nvimdev/hlsearch.nvim',
      event = 'BufRead',
      config = function() require('hlsearch').setup() end
    },

    -- color scheme
    { "yorik1984/newpaper.nvim",
      priority = 1000,
      config = function()
        require("newpaper").setup({ style = "light" })
        vim.cmd.colorscheme("newpaper")
        vim.opt.foldcolumn = "1"
      end,
    },

    -- highlight 'f' character
    { 'rhysd/clever-f.vim',
      config = function()
        vim.g.clever_f_smart_case = 1
        vim.g.clever_f_across_no_line = 1
        vim.keymap.set('n', ';', '<Plug>(clever-f-repeat-forward)', { noremap = false })
      end,
    },

    -- vim-smoothie
    { 'karb94/neoscroll.nvim',
      opts = {
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb', },
      },
    },

    -- airline
    { 'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      options = {
        icons_enabled = true
      },
      config = function()
        local colors = {
          red = '#ca1243',
          grey = '#a0a1a7',
          black = '#383a42',
          white = '#f3f3f3',
          light_green = '#83a598',
          orange = '#fe8019',
          green = '#8ec07c',
        }

        local theme = {
          normal = {
            a = { fg = colors.white, bg = colors.black },
            b = { fg = colors.white, bg = colors.grey },
            c = { fg = colors.black, bg = colors.white },
            z = { fg = colors.white, bg = colors.black },
          },
          insert = { a = { fg = colors.black, bg = colors.light_green } },
          visual = { a = { fg = colors.black, bg = colors.orange } },
          replace = { a = { fg = colors.black, bg = colors.green } },
        }

        local empty = require('lualine.component'):extend()
        function empty:draw(default_highlight)
          self.status = ''
          self.applied_separator = ''
          self:apply_highlights(default_highlight)
          self:apply_section_separators()
          return self.status
        end

        -- Put proper separators and gaps between components in sections
        local function process_sections(sections)
          for name, section in pairs(sections) do
            local left = name:sub(9, 10) < 'x'
            for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
              table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
            end
            for id, comp in ipairs(section) do
              if type(comp) ~= 'table' then
                comp = { comp }
                section[id] = comp
              end
              comp.separator = left and { right = '' } or { left = '' }
            end
          end
          return sections
        end

        local function search_result()
          if vim.v.hlsearch == 0 then
            return ''
          end
          local last_search = vim.fn.getreg('/')
          if not last_search or last_search == '' then
            return ''
          end
          local searchcount = vim.fn.searchcount { maxcount = 9999 }
          return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
        end

        local function modified()
          if vim.bo.modified then
            return '+'
          elseif vim.bo.modifiable == false or vim.bo.readonly == true then
            return '-'
          end
          return ''
        end

        require('lualine').setup({
          options = {
            theme = theme,
            component_separators = '',
            section_separators = { left = '', right = '' },
          },
          sections = process_sections {
            lualine_a = { 'mode' },
            lualine_b = {
              'branch',
              'diff',
              {
                'diagnostics',
                source = { 'nvim' },
                sections = { 'error' },
                diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
              },
              {
                'diagnostics',
                source = { 'nvim' },
                sections = { 'warn' },
                diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
              },
              { 'filename', file_status = false, path = 1 },
              { modified, color = { bg = colors.red } },
              {
                '%w',
                cond = function()
                  return vim.wo.previewwindow
                end,
              },
              {
                '%r',
                cond = function()
                  return vim.bo.readonly
                end,
              },
              {
                '%q',
                cond = function()
                  return vim.bo.buftype == 'quickfix'
                end,
              },
            },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { search_result, 'filetype' },
            lualine_z = { '%l:%c', '%p%%/%L' },
          },
          inactive_sections = {
            lualine_c = { '%f %y %m' },
            lualine_x = {},
          },
        })
      end
    },

    -- bufferline
    { 'akinsho/bufferline.nvim',
      dependencies = 'nvim-tree/nvim-web-devicons',
      config = function()
        require('bufferline').setup({
          options = {
            right_mouse_command = "bdelete! %d",
            tab_size = 3,
            max_name_length = 100,
            name_formatter = function(buf)
              if string.find(buf.name, 'index') then
                tail = buf.path:sub(1, buf.path:len() - buf.name:len())
                return tail:match("([^/]+)/$") .. '/' .. buf.name
              end
              return buf.name
            end,
            offsets = {
              {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = false,
              }
            },
            separator_style = 'slant',
            hover = {
              enabled = true,
              delay = 150,
              reveal = {'close'}
            },
            custom_filter = function(buf_number, buf_numbers)
              -- filter out filetypes you don't want to see
              if vim.bo[buf_number].filetype ~= "qf" then
                return true
              end
            end,
          }
        })
      end,
    },

    -- git
    { 'tpope/vim-fugitive' },
    { 'jreybert/vimagit' },
    { 'junegunn/gv.vim', cmd = 'GV' },
    { 'akinsho/git-conflict.nvim',
      version = "*",
      config = true,
      opts = {
        default_mappings = {
          ours = 'co',
          theirs = 'ct',
          both = 'cb',
          next = ']c',
          prev = '[c',
        },
      }
    },

    -- auto pairs
    { 'windwp/nvim-autopairs',
      event = 'InsertEnter',
      opts = {
        check_ts = true,  -- Treesitter integration
        disable_filetype = { 'TelescopePrompt' }
      }
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
      config = function()
        require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
        })
      end
    },

    -- quality of life
    { 'svban/YankAssassin.vim', event = 'VeryLazy' },

    -- bufonly
    { "numtostr/BufOnly.nvim", cmd = "BufOnly" },

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

    { "pogyomo/submode.nvim", lazy = true },

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

    { 'FooSoft/vim-argwrap' },

    { 'axlebedev/yank-filename.nvim',
      cmd = { 'YankFileName', 'YankFileNameForDebug', 'YankGithubURLMaster', 'YankGithubURL' },
    },

    -- Clear highlight on cursor move
    { 'folke/flash.nvim',
      event = "VeryLazy",
    },

    { 'rcarriga/nvim-notify',
      event = "VeryLazy",
      opts = {
        timeout = 2000,
        top_down = false,
        render = 'compact',
        stages = 'fade',
      },
    },

    { 'axlebedev/nvim-js-fastlog',
      opts = { js_fastlog_prefix = '11111' },
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

    { "axlebedev/nvim-footprints",
      opts = { footprintsColor = "#D9D9D9" }
    },

    { 'isomoar/vim-css-to-inline' },

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

    { 'osyo-manga/vim-trip',
      event = "VeryLazy",
      config = function()
        vim.keymap.set('n', '<C-a>', '<Plug>(trip-increment-ignore-minus)')
        vim.keymap.set('n', '<C-x>', '<Plug>(trip-decrement-ignore-minus)')
      end,
    },

    -- textobj
    { "chrisgrieser/nvim-various-textobjs",
      event = "VeryLazy",
      opts = { 
        keymaps = {
          useDefaults = true 
        }
      },
    },

    -- npm i -g vscode-langservers-extracted (?)
    -- npm i -g @fsouza/prettierd vscode-langservers-extracted
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

    { "brenoprata10/nvim-highlight-colors",
      config = function()
        require('nvim-highlight-colors').setup({})
      end
    }
  },
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup='IncSearch', timeout=500 })
  end,
})

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
    end,
  })
vim.api.nvim_set_keymap('i', '<Tab>', ' pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', { expr = true, silent = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
      vim.keymap.set("n", "o", "<CR>", { buffer = true, silent = true })
      vim.keymap.set("n", "<CR>", "<CR>", { buffer = true, silent = true })
      vim.keymap.set("n", "q", "<cmd>cclose | wincmd l<cr>", { buffer = true, silent = true, remap = true })
    end,
  })

vim.keymap.set('v', 'S', '<Plug>VSurround', {remap = true})
vim.keymap.set('x', 'S', '<Plug>VSurround', {remap = true})

vim.keymap.set({ "o", "x" }, "as", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
vim.keymap.set({ "o", "x" }, "is", '<cmd>lua require("various-textobjs").subword("inner")<CR>')
vim.keymap.set({ "o", "x" }, "ie", '<cmd>lua require("various-textobjs").entireBuffer()<CR>')
vim.keymap.set({ "o", "x" }, "il", '<cmd>lua require("various-textobjs").lineCharacterwise("inner")<CR>')


vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({
            border = "rounded",
            focusable = false,
            relative = "cursor",
            row = 1,  -- Positions above cursor (use vim.api.nvim_win_get_cursor(0)[1] for dynamic)
            col = 20, -- Offset right to avoid "under" cursor overlap
          })
      end, { buffer = args.buf })
  end,
})

vim.keymap.set({ "n" }, "*", function()
  if vim.v.hlsearch == 1 then
    vim.api.nvim_feedkeys("*", "n", true)
  else
    local word = vim.fn.expand("<cword>")
    if word == "" then return "" end

    local pat = [[\V\<]] .. vim.fn.escape(word, [[/\]]) .. [[\>]]
    vim.fn.setreg("/", pat)
    vim.fn.histadd("/", pat)
    vim.o.hlsearch = true
    vim.fn.search(pat, "n")  -- 'n' flag = no movement
  end
end)

vim.keymap.set('n', '<C-m>', vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_prev, { noremap = true, silent = true })

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●", -- Example: a red circle
      [vim.diagnostic.severity.WARN]  = "▲", -- Example: a yellow triangle
      [vim.diagnostic.severity.INFO]  = "i",
      [vim.diagnostic.severity.HINT]  = "?",
    },
    -- You can also configure highlights, etc.
  },
  update_in_insert = true,
  float = {
    header = false,
    border = 'rounded',
  }
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    callback = function()
      for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(winid).zindex then
          return
        end
      end
      vim.diagnostic.open_float({
          scope = "cursor",
          focusable = false,
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
  })

-- " Resize to 40 columns (from any window, no focus change)
-- :NvimTreeResize 40
--
-- " Make 25% of screen width
-- :NvimTreeResize 25%
--
-- " Lua equivalent
-- vim.cmd("NvimTreeResize 40")

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
