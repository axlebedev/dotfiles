" Delete trailing white space
function! trailingspace#DeleteTrailingWS() abort
    let l:cursor_pos = getpos(".")

    :%substitute/\v^(.+\S)(\s*)$/\1/

    call setpos('.', l:cursor_pos)
endfunction
