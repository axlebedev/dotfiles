" paste but keep register
function! visualpaste#VisualPaste() abort
    let currentMode = visualmode()
    if (currentMode ==# 'v')
        :execute "normal! gv\"_c\<esc>p"
    elseif (currentMode ==# 'V')
        :execute "normal! gv\"_dP`]"
    elseif
        :execute "normal! gvp"
    endif
endfunction
