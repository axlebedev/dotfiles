local plugins = {
    -- git
    { 'tpope/vim-fugitive',
        config = function()
            vim.keymap.set("n", "<C-g><C-b>", function() vim.cmd('G blame') end)
            vim.keymap.set("n", "<C-g><C-w>", function()
                vim.cmd('G add %')
                print('Git add ' .. vim.fn.expand('%:.'))
                local popupUtils = require('utils/popup')

                local message = '  Git add %'
                local width = #message + 4
                popupUtils.createPopup(
                  { '', message },
                  {
                    closeTimeout = 700,
                    width = width,
                    height = 3,
                    row = 5,
                    col = math.floor((vim.o.columns - width) / 2),
                  })
            end)
        end
    },
    { 'jreybert/vimagit',
        config = function()
            vim.keymap.set("n", "<C-g><C-g>", function() --  MagitF
                if vim.o.ft == 'qf' then
                    vim.cmd('wincmd k | wincmd l')
                end
                vim.cmd('Magit')
            end)

            vim.api.nvim_create_autocmd('User', {
                group = vim.api.nvim_create_augroup('autoupdate_on_vimagit', { clear = true }),
                pattern = 'VimagitUpdateFile',
                command = 'checktime'
            })
        end
    },
    { 'junegunn/gv.vim',
        cmd = 'GV',
        config = function()
            vim.keymap.set("n", "<C-g><C-v>", function() vim.cmd('GV!') end)
        end
    },
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
        },
    },
    { 'sindrets/diffview.nvim',
        config = function()
            local actions = require("diffview/actions")
            require("diffview").setup({
                keymaps = {
                    view = {
                        -- Navigate to the next/previous commit in the history from the diff buffer
                        -- TODO: форкнуть diffview и сделать чтобы select_next_entry не ходил по кругу (не wrap)
                        { "n", "<C-n>", actions.select_next_entry, { desc = "Next commit (newer)" } },
                        { "n", "<C-p>", actions.select_prev_entry, { desc = "Previous commit (older)" } },
                    },
                    file_history_panel = {
                        -- Same mappings for the sidebar for consistency
                        { "n", "<C-n>", actions.select_next_entry, { desc = "Next commit" } },
                        { "n", "<C-p>", actions.select_prev_entry, { desc = "Previous commit" } },
                    },
                },
            })

        vim.api.nvim_set_hl(0, "DiffviewFilePanelSelected", { bg = "#ffa500", bold = true, fg = "#FFFFFF" })
        end,
    },
}

local init_config = function()
    local builtin = require('telescope/builtin')
    vim.keymap.set("n", "<C-g><C-u>", function()
      builtin.find_files({
          prompt_title = "Unmerged Files",
          find_command = { "git", "diff", "--name-only", "--diff-filter=U" },
        })
    end, { desc = "Git unmerged files" })


    vim.keymap.set('n', '<C-g><C-f>', function()
      local pickers = require('telescope.pickers')
      local finders = require('telescope.finders')
      local conf = require('telescope.config').values
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      pickers.new({}, {
          prompt_title = 'Branches',
          finder = finders.new_oneshot_job(
            { 'sh', vim.env.HOME .. '/dotfiles/fish/sortedBranch.sh' },
            {}
            ),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                vim.cmd('Gedit ' .. (selection.value or selection[1]) .. ':%')
              end
            end)
            return true
          end,
        }):find()
    end, { silent = true })
    -- nnoremap <silent> <C-g><C-f> <ScriptCmd>fzf#run(fzf#wrap({ source: 'sh ~/dotfiles/fish/sortedBranch.sh', sink: g:GeditFile }))<CR>
end

return {
    plugins = plugins,
    init_config = init_config,
}
