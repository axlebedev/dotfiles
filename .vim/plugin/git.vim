vim9script

def Magit()
    if (&filetype == 'qf')
        wincmd k
    endif
    var isStartify = getbufinfo()->len() <= 2 && &filetype == 'startify'
    if (isStartify)
        MagitOnly
    else
        Magit
    endif
enddef
nnoremap <C-g><C-g> <ScriptCmd>Magit()<CR>
nnoremap <C-g><C-b> <CMD>Git blame<cr>
nnoremap <C-g><C-v> <CMD>GV!<cr>
# stage current file
nnoremap <C-g><C-w> <CMD>Gw<cr> 
def g:GeditFile(branch: string)
    execute 'Gedit ' .. branch .. ':%'
enddef
# open current file version in branch
nnoremap <silent> <C-g><C-f> <ScriptCmd>fzf#run(fzf#wrap({ source: 'sh ~/dotfiles/fish/sortedBranch.sh', sink: g:GeditFile }))<CR>

