function! s:GetMaxFoldlevelInCurrentBuffer() abort
    let &foldmethod = 'syntax'
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
    let &foldmethod = 'syntax'
    let &foldlevel += 1
endfunction

function! increasefoldlevel#decreaseFoldlevel() abort
    let &foldmethod = 'syntax'
    let maxFoldlevel = s:GetMaxFoldlevelInCurrentBuffer()
    if (&foldlevel - 1 >= maxFoldlevel) 
        let &foldlevel = maxFoldlevel - 1
    else
        let &foldlevel -= 1
    endif
endfunction
