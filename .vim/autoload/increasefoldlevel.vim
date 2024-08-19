function! s:GetMaxFoldlevelInCurrentBuffer() abort
    let &l:foldmethod = 'syntax'
    let maxFoldlevel = 1
    let currentLine = 1
    let maxline = line('$')
    while currentLine <= maxline
        let currentLineFoldlevel = foldlevel(currentLine)
        if (currentLineFoldlevel > maxFoldlevel)
            let maxFoldlevel = currentLineFoldlevel
        endif
        let currentLine += 1
    endwhile
    return maxFoldlevel
endfunction

function! increasefoldlevel#increaseFoldlevel() abort
    let &l:foldmethod = 'syntax'
    let &l:foldlevel += 1
endfunction

function! increasefoldlevel#decreaseFoldlevel() abort
    let &l:foldmethod = 'syntax'
    let maxFoldlevel = s:GetMaxFoldlevelInCurrentBuffer()
    if (&l:foldlevel - 1 >= maxFoldlevel) 
        let &l:foldlevel = maxFoldlevel - 1
    else
        let &l:foldlevel -= 1
    endif
endfunction
