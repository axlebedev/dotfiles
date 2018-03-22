" Delete trailing white space
function! trailingspace#DeleteTrailingWS() abort
    let l:cursor_pos = getpos(".")

    %s/\s\+$//ge

    call setpos('.', l:cursor_pos)
endfunction
