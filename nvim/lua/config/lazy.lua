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

    -- Automatically create parent directories on write when don't exist already.
    { 'pbrisbin/vim-mkdir' },

    -- Make '.' work on plugin commands (not all maybe)
    { 'tpope/vim-repeat' }, -- TODO: nnoremap <Plug>(RepeatRedo) U

    -- Start screen for vim
    {
      'goolord/alpha-nvim',
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
    {
      'nvim-tree/nvim-tree.lua', -- NvimTreeToggle
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('nvim-tree').setup {
          view = { width = 35, side = 'left' },
          filters = { dotfiles = false },  -- Show hidden files (like NERDTree)
          git = { enable = true },
          actions = { open_file = { quit_on_open = false } },
          renderer = {
            icons = { glyphs = { default = '', git = { unstaged = '✗' } } },
            highlight_git = true,
          },
        }
      end,
    },

    -- fzf
    {
      'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
      config = function()
        require('telescope').setup{
          defaults = {
            preview = false,
          },
          pickers = {},
          extensions = {},
        }
      end
    },

    -- Markdown
    {
      'iamcco/markdown-preview.nvim',
      cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
      build = 'cd app && yarn install',
      init = function()
        vim.g.mkdp_filetypes = { 'markdown' }
      end,
      ft = { 'markdown' },
    },

    -- open browser
    {
      'tyru/open-browser.vim',
      keys = {
        { '<F3>', '<Plug>(openbrowser-smart-search)', mode = 'n' },
        { '<F3>', '<Plug>(openbrowser-smart-search)', mode = 'v' },
      },
    },

    -- clear hlsearch on cursor move
    {
      'nvimdev/hlsearch.nvim',
      event = 'BufRead',
      config = function()
        require('hlsearch').setup()
      end
    },

    -- color scheme
    {
      'NLKNguyen/papercolor-theme',
      priority = 1000, -- ensures the colorscheme loads first
    },

    -- highlight 'f' character
    {
      'rhysd/clever-f.vim',
      config = function()
        vim.g.clever_f_smart_case = 1
        vim.g.clever_f_across_no_line = 1
        vim.keymap.set('n', ';', '<Plug>(clever-f-repeat-forward)', { noremap = false })
      end,
    },

    -- vim-smoothie
    {
      'karb94/neoscroll.nvim',
      opts = {
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb', },
      },
    },

    -- airline
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      options = {
        theme = 'papercolor',
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
    {
      'akinsho/bufferline.nvim',
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
                separator = true,
              }
            },
            separator_style = 'slant',
            hover = {
              enabled = true,
              delay = 150,
              reveal = {'close'}
            }
          }
        })
      end,
    },

    -- git
    { 'tpope/vim-fugitive' },
    { 'jreybert/vimagit' },
    { 'junegunn/gv.vim', cmd = 'GV' }, -- Lazy-load on command 

    -- auto pairs
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      opts = {
        check_ts = true,  -- Treesitter integration
        disable_filetype = { 'TelescopePrompt' }
      }
    },

    -- true/false
    {
      'AndrewRadev/switch.vim',
      keys = '<C-t>',
      config = function()
        vim.keymap.set('n', '<C-t>', '<cmd>Switch<CR>')
      end
    },

    --
    { 'tpope/vim-surround', keys = { 'ds', 'cs', 'ys', 'S' } },

    -- quality of life
    { 'svban/YankAssassin.vim', event = 'VeryLazy' },

    -- bufonly
    {
      'schickling/vim-bufonly',
      keys = 'bo',
      config = function() vim.keymap.set('n', 'bo', '<cmd>BufOnly<CR>') end
    },

    --
    {
      'RRethy/vim-illuminate',
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

    {
      "axlebedev/find-my-cursor.nvim",
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

    {
      'axlebedev/yank-filename.nvim',
      cmd = { 'YankFileName', 'YankFileNameForDebug', 'YankGithubURLMaster', 'YankGithubURL' },
    },

    -- Clear highlight on cursor move
    { 'folke/flash.nvim', event = "VeryLazy" }
    -- }}} WORKS, nothing to do ===================================================================

    -- textobj
    -- { 'kana/vim-textobj-user' },
    -- { 'kana/vim-textobj-entire' },
    -- { 'kana/vim-textobj-indent' },
    -- { 'kana/vim-textobj-lastpat' },
    -- { 'kana/vim-textobj-line' },
    -- { 'kana/vim-textobj-underscore' },
    -- { 'glts/vim-textobj-comment' },
    -- -- { 'rhysd/vim-textobj-anyblock' }, TODO. Not work (vim and nvim)
    -- { 'Julian/vim-textobj-variable-segment' },
  },
})

vim.cmd('colorscheme PaperColor')
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank { higroup='IncSearch', timeout=200 } end,
})

-- -- Enable TypeScript via the Language Server Protocol (LSP)
-- vim.lsp.enable('tsserver')
--
-- -- Set the TS config for the LSP
-- vim.lsp.config('tsserver', {
--   -- Make sure this is on your path
--   cmd = {'typescript-language-server', '--stdio'},
--   filetypes = { 'typescript' },
--   -- This is a hint to tell nvim to find your project root from a file within the tree
--   root_dir = vim.fs.root(0, {'package.json', '.git'}),
--   on_attach = on_attach,
--   capabilities = capabilities,
--   -- optional settings = {...} go here, refer to language server code: https://github.com/typescript-language-server/typescript-language-server/blob/5c483349b7b4b6f79d523f8f4d854cbc5cec7ecd/src/ts-protocol.ts#L379
-- })
--
-- -- lsp keymaps
-- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
-- vim.keymap.set('n', '<leader>f', function()
--   vim.lsp.buf.format { async = true }
-- end, {})
