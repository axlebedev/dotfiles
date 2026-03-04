return {
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
          lightgrey = '#cbcccb',
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
            c = { fg = colors.black, bg = colors.lightgrey },
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
            vim.wo.cursorline = true
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
            icons = {
              git_placement = "after",
              glyphs = {
                default = '',
                git = {
                  unstaged = '●',
                  staged = '➕',
                  unmerged = '⚡',
                  renamed = '➜',
                  untracked = '❓',
                  deleted = '',
                  ignored = '◌',
                },
              },
            },
            highlight_git = false,
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
                ["<esc>"] = actions.close,
                ["<C-u>"] = false,
              },
              n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<esc>"] = actions.close,
              },
            },
            layout_config = {
                width = 0.55,
                height = 0.6,
            }
          },
          pickers = {},
          extensions = {},
        }

        local builtin = require('telescope/builtin')
        vim.keymap.set('n', '<leader>t', function() builtin.find_files({ hidden = true }) end, { noremap = false })
        vim.keymap.set('v', '<leader>t', function() builtin.find_files({
                default_text = require('utils/utils').get_visual_selection(),
                hidden = true,
          }) end, {noremap = false})
        vim.keymap.set('n', '<leader>b', builtin.buffers, { noremap = false })
        vim.keymap.set('n', '<C-p>', builtin.commands, { noremap = false })
        vim.keymap.set('n', 'sft', builtin.filetypes, { noremap = false })
      end
    },
}
