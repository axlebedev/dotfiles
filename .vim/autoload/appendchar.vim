" append a char
function! appendchar#AppendChar(char) abort
    let saved_q_register = @q

    let l:cursor_pos = getpos(".")
    execute 'keepjumps normal! g_a' . a:char
    call setpos('.', l:cursor_pos)

    let @q = saved_q_register
endfunction
