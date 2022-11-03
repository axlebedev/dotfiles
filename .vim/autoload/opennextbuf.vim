" Skip quickfix on traversing buffers
function! opennextbuf#OpenNextBuf(prev) abort
    let l:command = a:prev == 1 ? "bprev" : "bnext"
    :execute l:command
    if (&buftype ==# 'quickfix' || &buftype ==# 'terminal')
        call opennextbuf#OpenNextBuf(a:prev)
    endif
endfunction
