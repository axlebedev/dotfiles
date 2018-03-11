" Google it
function! google#Google(pattern) abort
    let q = substitute(a:pattern, '["\n]', ' ', 'g')
    let q = substitute(q, '[[:punct:] ]',
                \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
    echom q
    call system(printf('xdg-open "https://www.google.com/search?%sq=%s"', '', q))
endfunction
