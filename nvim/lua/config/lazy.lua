-- for nvimtree: disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.opt.mousemoveevent = true
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

    -- WORKS, nothing to do {{{ ===================================================================
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
        highlight = { enable = true },
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

-- Start screen for vim
{ 'goolord/alpha-nvim',
dependencies = { 'nvim-mini/mini.icons' },
config = function ()
  local startify = require'alpha.themes.startify'
  startify.section.header.val = {}
  startify.config.opts.keymap = { press = { 'o', '<CR>' } }
  table.insert( startify.section.bottom_buttons.val, startify.button('u', 'Plug update' , '<cmd>Lazy update<CR>'))
  require'alpha'.setup(startify.config)
end
    },

    -- NERDTree
    { 'nvim-tree/nvim-tree.lua', -- NvimTreeToggle
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        view = {
          width = 35,
          side = 'left',
          number = false,
          relativenumber = false,
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

  -- { -- этот плагин ломает FindCursor и боковую line для фолдов
  --   "lukas-reineke/indent-blankline.nvim",
  --   main = "ibl",
  --   opts = {},
  --   config = function()
  --     local hooks = require "ibl.hooks"
  --     -- create the highlight groups in the highlight setup hook, so they are reset
  --     -- every time the colorscheme changes
  --     hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  --       vim.api.nvim_set_hl(0, 'IblIndent', { fg = "#dddddd" })
  --     end)
  --     require("ibl").setup({
  --       indent = { char = '┊', highlight = 'IblIndent' },
  --       scope = { enabled = false }
  --     })
  --   end
  -- },

  -- fzf
  { 'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- optional but recommended
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
  config = function()
    require('hlsearch').setup()
  end
},

-- color scheme
{
  "projekt0n/github-nvim-theme",
  lazy = false,
  priority = 1000,
  config = function()
    require("github-theme").setup({})
    vim.cmd.colorscheme("github_light")
    vim.opt.cursorline = true
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
  -- theme = 'tokyonight',
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

  require('lualine').setup {
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
  }
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
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional
      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<C-g><C-g>", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
    },
    opts = {
      kind = 'vsplit',
      diff_viewer = 'diffview',
      sections = {
        staged    = { folded = false },
        unstaged  = { folded = false },
        untracked = { folded = false },
        stashes   = { folded = true, hidden = true  },
        unpulled_upstream   = { folded = true, hidden = true },
        unmerged_upstream   = { folded = true, hidden = true },
        recent    = { folded = true, hidden = true  },
      },
    }
  },
  { 'junegunn/gv.vim', cmd = 'GV' }, -- Lazy-load on command 

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
keys = '<C-t>',
config = function()
  vim.keymap.set('n', '<C-t>', '<cmd>Switch<CR>')
end
    },

    --
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
  { "numtostr/BufOnly.nvim",
  cmd = "BufOnly",
},

--
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

    { dir = "~/github/find-my-cursor.nvim",
    lazy = true,
    cmd = 'FindCursor',
    opts = {
      FindCursorHookPre = function()
        -- FootprintsDisable
        -- IlluminationDisable
      end,
      FindCursorHookPost = function()
        -- FootprintsEnable
        -- IlluminationEnable
      end,
    },
  },

  { 'FooSoft/vim-argwrap' },

  { 'axlebedev/yank-filename.nvim',
  cmd = { 'YankFileName', 'YankFileNameForDebug', 'YankGithubURLMaster', 'YankGithubURL' },
},

-- Clear highlight on cursor move
{
  'folke/flash.nvim',
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
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' %d↘ '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, {chunkText, hlGroup})
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          break
        end
        curWidth = curWidth + chunkWidth
      end

      local croppedWidth = 0
      while croppedWidth < sufWidth do
        local remainingWidth = sufWidth - croppedWidth
        local text = newVirtText[1][1]
        local textWidth =  vim.fn.strdisplaywidth(text)
        if textWidth < remainingWidth then
          table.remove(newVirtText, 1)
        else
          newVirtText[1][1] = string.sub(text, sufWidth - croppedWidth + 1)
        end
        croppedWidth = croppedWidth + textWidth
      end
      table.insert(newVirtText, 1, {suffix, 'MoreMsg'})
      return newVirtText
    end
  },
  },

{ "axlebedev/nvim-footprints",
config = function()
  require("nvim-footprints").setup({
    footprintsColor = "#D9D9D9",
  })
end
    },

    { 'isomoar/vim-css-to-inline' },

    { 'windwp/nvim-ts-autotag',
    -- opts = {
    --   enable_close = true, -- Auto close tags
    --   enable_rename = true, -- Auto rename pairs of tags
    --   enable_close_on_slash = false -- Auto close on trailing </
    -- },
  },

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
config = function()
  vim.keymap.set('n', '<C-a>', '<Plug>(trip-increment-ignore-minus)')
  vim.keymap.set('n', '<C-x>', '<Plug>(trip-decrement-ignore-minus)')
end,
    },
    -- }}} WORKS, nothing to do ===================================================================

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
    -- { 'neovim/nvim-lspconfig',
    --   config = function()
    --     -- go install github.com/mattn/efm-langserver@latest
    --     local lang = {
    --       formatCommand = "eslint_d --stdin --stdin-filename ${INPUT} --fix-to-stdout",
    --       lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    --       lintStylish = true,
    --       lintFormats = {"%f:%l:%c: %m"}
    --     }
    --     vim.lsp.config(
    --       'efm',
    --       {
    --         settings = {
    --           filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    --           init_options = { documentFormatting = true },
    --           settings = {
    --             rootMarkers = {".git/", "eslint.config.mjs", "package.json"},
    --             languages = {
    --               javascript = lang,
    --               typescript = lang,
    --               javascriptreact = lang,
    --               typescriptreact = lang,
    --             },
    --           },
    --         }
    --       }
    --     )
    --   end
    -- },
    -- {
    --   'esmuellert/nvim-eslint',
    --   on_attach = function(client, bufnr)
    --     require('eslint').setup({ })
    --   end
    -- },
    -- {
    --   'dense-analysis/ale',
    --   ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html' },
    --   config = function()
    --     -- Disable the floating preview windows that cause the API error
    --     vim.g.ale_floating_preview = 0
    --     vim.g.ale_hover_to_floating_preview = 0
    --
    --     -- Enable virtual text instead to see warnings/errors inline
    --     vim.g.ale_virtualtext_cursor = 1
    --
    --     -- Customize sign colors
    --     vim.api.nvim_set_hl(0, 'ALEErrorSign', { fg = '#ff0000', bg = '#330000' })
    --     vim.api.nvim_set_hl(0, 'ALEWarningSign', { fg = '#ffff00', bg = '#333300' })
    --     vim.api.nvim_set_hl(0, 'ALEInfoSign', { fg = '#00ff00', bg = '#003300' })
    --
    --     -- ALE plugin setup
    --     vim.g.ale_lint_on_save = 0
    --     vim.g.ale_open_list = 0
    --
    --     -- Sign column configuration - this is likely causing the issue
    --     -- Remove or comment these out if they're causing problems:
    --     vim.g.ale_change_sign_column_color = 1
    --     vim.g.ale_sign_column_always = 1
    --
    --     -- Alternative: Configure sign column properly for Neovim
    --     -- This preserves the line numbers and folds
    --     vim.opt.signcolumn = 'auto'  -- or 'yes:1' for minimal width
    --     vim.g.ale_sign_error = '♿'
    --     vim.g.ale_sign_warning = ''
    --
    --     -- Rest of your settings
    --     vim.g.ale_set_loclist = 0
    --     vim.g.ale_set_quickfix = 0
    --     -- vim.g.ale_virtualtext_cursor = 0
    --     vim.g.ale_disable_lsp = 1
    --
    --     -- Test settings
    --     vim.g.ale_cursor_detail = 1
    --     vim.g.ale_set_balloons = 1
    --     vim.g.ale_hover_to_preview = 1
    --     -- vim.g.ale_floating_preview = 1
    --     vim.g.ale_echo_cursor = 0
    --     vim.g.ale_echo_delay = 2000
    --     vim.g.ale_detail_to_floating_preview = 1
    --     vim.g.ale_floating_preview_popup_opts = { close = 'click', borderchars = { ' ' } }
    --     vim.g.ale_hover_cursor = 1
    --
    --     -- Pattern options
    --     vim.g.ale_pattern_options = { ['\\.min\\.js$'] = { ale_enabled = 0 } }
    --
    --     -- ESLint options
    --     vim.g.ale_javascript_eslint_options = "--rule 'notice/notice: off' --rule 'prettier/prettier: off' --rule 'project-structure/file-structure: off' --rule 'arrow-body-style: off'"
    --     vim.g.ale_javascript_eslint_executable = 'npm -s run lint %'
    --     vim.g.ale_typescript_tslint_executable = 'npm -s run lint %'
    --
    --     -- Fixers configuration
    --     vim.g.ale_fixers = {
    --       javascript = { 'eslint' },
    --       typescript = { 'eslint' },
    --     }
    --
    --     -- Linters configuration
    --     vim.g.ale_linters = {
    --       javascript = { 'eslint' },
    --       typescript = { 'eslint' }
    --     }
    --
    --     -- Key mappings
    --     vim.api.nvim_set_keymap('n', '<C-m>', '<Plug>(ale_next_wrap)', { noremap = true, silent = true })
    --     vim.api.nvim_set_keymap('n', '<C-M>', '<Plug>(ale_next_wrap)', { noremap = true, silent = true })
    --
    --     vim.opt.signcolumn = 'yes:1'
    --     -- maybe vim.opt.signcolumn = 'number'
    --   end
    -- },
  },
})

-- vim.cmd('colorscheme PaperColor')
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank { higroup='IncSearch', timeout=500 } end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'typescriptreact', 'javascriptreact' },
  callback = function()
    vim.treesitter.start()

    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Enable TypeScript via the Language Server Protocol (LSP)
vim.lsp.enable('tsserver')

-- Set the TS config for the LSP
vim.lsp.config('tsserver', {
  -- Make sure this is on your path
  cmd = {'typescript-language-server', '--stdio'},
  filetypes = { 'javascript', 'typescript', 'typescriptreact', 'javascriptreact' },
  -- This is a hint to tell nvim to find your project root from a file within the tree
  root_dir = vim.fs.root(0, {'package.json', '.git'}),
  on_attach = on_attach,
  capabilities = capabilities,
  -- optional settings = {...} go here, refer to language server code: https://github.com/typescript-language-server/typescript-language-server/blob/5c483349b7b4b6f79d523f8f4d854cbc5cec7ecd/src/ts-protocol.ts#L379
})

--------------------------------------------------------------------

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
        -- and cap field to 25 chars
        --local abbr = item.label
        --abbr = abbr:match("[%w_.]+.*") or abbr
        --abbr = #abbr > 25 and abbr:sub(1, 24) .. "…" or abbr
        --
        -- Remove return value
        --local menu = ""

        -- Only show abbr name, remove leading misc chars (bullets etc.),
        -- and cap field to 15 chars
        local abbr = item.label
        abbr = abbr:gsub("%b()", ""):gsub("%b{}", "")
        abbr = abbr:match("[%w_.]+.*") or abbr
        abbr = #abbr > 15 and abbr:sub(1, 14) .. "…" or abbr

        -- Cap return value field to 15 chars
        local menu = item.detail or ""
        menu = #menu > 15 and menu:sub(1, 14) .. "…" or menu

        return { abbr = abbr, menu = menu }
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
