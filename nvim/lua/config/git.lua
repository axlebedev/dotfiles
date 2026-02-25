local plugins = {
    -- git
    { 'tpope/vim-fugitive', 
        config = function()
            vim.keymap.set("n", "<C-g><C-b>", function() vim.cmd('G blame') end)
            vim.keymap.set("n", "<C-g><C-w>", function()
                vim.cmd('G add %')
                print('Git add ' .. vim.fn.expand('%:.'))
            end)
        end
    },
    { 'jreybert/vimagit',
        config = function()
            local function MagitF()
                if vim.o.ft == 'qf' then
                    vim.cmd('wincmd k | wincmd l')
                end
                vim.cmd('Magit')
            end

            vim.keymap.set("n", "<C-g><C-g>", MagitF)
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
        }
    },
}

local init_config = function()
    -- vim.keymap.set("n", "<C-g><C-u>", function() unmerged() end)
    -- vim.keymap.set("n", "<C-g><C-w>", function() vim.cmd('G add %') end)
    -- function GeditFile(branch)
    --     vim.cmd('Gedit ' .. branch .. ':%')
    -- end
    -- vim.keymap.set("n", "<C-g><C-f>", function() vim.cmd('Gw') end)
    -- nnoremap <silent> <C-g><C-f> <ScriptCmd>fzf#run(fzf#wrap({ source: 'sh ~/dotfiles/fish/sortedBranch.sh', sink: g:GeditFile }))<CR>

    -- def Cgci()
    --     if (&ft == 'nerdtree')
    --         wincmd l
    --     endif
    --     var current_branch = fugitive#Head()
    --     if (current_branch == 'master')
    --         Commits --first-parent
    --     else
    --         Commits --branches --not master
    --     endif
    -- enddef
    -- nnoremap <C-g><C-i> <ScriptCmd>Cgci()<CR>
end

return {
    plugins = plugins,
    init_config = init_config,
}
