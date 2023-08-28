vim9script

# Skip quickfix on traversing buffers
export def OpenNextBuf(prev: bool)
    var command = prev ? "bprev" : "bnext"
    :execute command
    if (&buftype ==# 'quickfix' || &buftype ==# 'terminal')
        OpenNextBuf(prev)
    endif
enddef
