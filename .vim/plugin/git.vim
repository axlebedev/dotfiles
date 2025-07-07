vim9script

import autoload '../autoload/unmerged.vim'

g:fzf_commits_log_options = "--color --graph --pretty=format:'%C(cyan)%h%Creset %Cgreen%<(11)%cd %C(bold blue)<%an> -%C(yellow)%d%Creset %s%Creset' --date='human' --abbrev-commit"

def Magit()
    if (&filetype == 'qf')
        wincmd k
    endif
    Magit
enddef
nnoremap <C-g><C-g> <ScriptCmd>Magit()<CR>
nnoremap <C-g><C-b> <CMD>Git blame<cr>
nnoremap <C-g><C-v> <CMD>GV!<cr>
nnoremap <C-g><C-u> <ScriptCmd>unmerged.Unmerged()<cr>
# stage current file
nnoremap <C-g><C-w> <CMD>Gw<cr> 
def g:GeditFile(branch: string)
    execute 'Gedit ' .. branch .. ':%'
enddef
# open current file version in branch
nnoremap <silent> <C-g><C-f> <ScriptCmd>fzf#run(fzf#wrap({ source: 'sh ~/dotfiles/fish/sortedBranch.sh', sink: g:GeditFile }))<CR>

nnoremap <C-g><C-o> <ScriptCmd>Git checkout %<CR>

def Cgci()
    if (&ft == 'nerdtree')
        wincmd l
    endif
    var current_branch = fugitive#Head()
    if (current_branch == 'master')
        Commits --first-parent
    else
        Commits --branches --not master
    endif
enddef
nnoremap <C-g><C-i> <ScriptCmd>Cgci()<CR>
