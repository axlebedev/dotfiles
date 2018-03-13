" append a char
function! appendchar#AppendChar(char) abort
    let l:cursor_pos = getpos(".")

    let text = substitute(
      \ getline('.'),
      \ '\v^(.*\S)(\s*)$',
      \ '\1' . a:char . '\2',
      \ ''
   \)
    call setline('.', text)

    call setpos('.', l:cursor_pos)
endfunction
