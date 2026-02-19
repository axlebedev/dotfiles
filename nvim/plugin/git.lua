vim.g.fzf_commits_log_options = "--color --graph --pretty=format:'%C(cyan)%h%Creset %Cgreen%<(11)%cd %C(bold blue)<%an> -%C(yellow)%d%Creset %s%Creset' --date='human' --abbrev-commit"

local function MagitF()
    if vim.o.ft == 'qf' then
        vim.cmd('wincmd k | wincmd l')
    end
    vim.cmd('Magit')
end

vim.keymap.set("n", "<C-g><C-g>", MagitF)
vim.keymap.set("n", "<C-g><C-b>", function() vim.cmd('G blame') end)
vim.keymap.set("n", "<C-g><C-v>", function() vim.cmd('GV!') end)
-- vim.keymap.set("n", "<C-g><C-u>", function() unmerged() end)
-- vim.keymap.set("n", "<C-g><C-w>", function() vim.cmd('G add %') end)
function GeditFile(branch)
    vim.cmd('Gedit ' .. branch .. ':%')
end
vim.keymap.set("n", "<C-g><C-f>", function() vim.cmd('Gw') end)
-- nnoremap <silent> <C-g><C-f> <ScriptCmd>fzf#run(fzf#wrap({ source: 'sh ~/dotfiles/fish/sortedBranch.sh', sink: g:GeditFile }))<CR>
--
vim.keymap.set("n", "<C-g><C-w>", function() vim.cmd('G add %') end)

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
