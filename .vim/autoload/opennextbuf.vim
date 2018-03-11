" Skip quickfix on traversing buffers
function! opennextbuf#OpenNextBuf(prev)
    let l:command = a:prev == 1 ? "bprev" : "bnext"
    :execute l:command
    if &buftype ==# 'quickfix'
        :execute l:command
    endif
endfunction
