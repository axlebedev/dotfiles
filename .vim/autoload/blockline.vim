" make single-line code to blocked
function! blockline#BlockLine() abort
    call cursor(line('.'), 1)
    call search('if')
    normal! f(%l"dDA {
    normal! o
    normal! "dp==o}

endfunction
