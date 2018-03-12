" Delete trailing white space
function! trailingspace#DeleteTrailingWS() abort
    let l:cursor_pos = getpos(".")

    let text = substitute(
      \ getline('.'),
      \ '\v^(.+\S)(\s*)$',
      \ '\1',
      \ ''
   \)
    call setline('.', text)

    call setpos('.', l:cursor_pos)
endfunction
