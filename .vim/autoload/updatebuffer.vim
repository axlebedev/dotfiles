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
