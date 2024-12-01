vim9script

# update current file
export def UpdateBuffer(force: bool)
    var winview = winsaveview()

    if (force) 
        e!
    else
        e
    endif

    winrestview(winview)
enddef

nnoremap <silent> <F5> <ScriptCmd>UpdateBuffer(0)<CR>
nnoremap <silent> <F5><F5> <ScriptCmd>UpdateBuffer(1)<CR>
