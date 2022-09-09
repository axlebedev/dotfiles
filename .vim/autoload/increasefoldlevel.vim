function! s:GetMaxFoldlevelInCurrentBuffer() abort
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
    echom 'increaseFoldlevel'
    let &foldlevel += 1
endfunction

function! increasefoldlevel#decreaseFoldlevel() abort
    echom 'decreaseFoldlevel start'
    let maxFoldlevel = s:GetMaxFoldlevelInCurrentBuffer()
    if (&foldlevel - 1 >= maxFoldlevel) 
        let &foldlevel = maxFoldlevel - 1
    else
        let &foldlevel -= 1
    endif
    echom 'decreaseFoldlevel end'
endfunction
