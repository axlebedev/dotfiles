" When using in the quickfix list, remove the item from the quickfix list.
function! removeqfitem#RemoveQFItem() abort
    let filename = expand("%")
    if (len(filename) > 0)
        delete " current line
        return
    endif

    let l:winview = winsaveview()
    let curpos = getpos('.')
    let curqfidx = line('.') - 1
    let qfall = getqflist()
    call remove(qfall, curqfidx)
    call setqflist(qfall, 'r')
    call winrestview(l:winview)
    call setpos('.', curpos)
endfunction

function! removeqfitem#RemoveQFItemsVisual() abort
    let curpos = getpos('.')

    let lineStart = getpos("'<")[1]
    let lineEnd = getpos("'>")[1]

    let filename = expand("%")
    if (len(filename) > 0)
        call deletebufline(bufname(''), lineStart, lineEnd)
        return
    endif

    let l:winview = winsaveview()

    let qfall = getqflist()

    let qfnew = qfall[:lineStart - 2] + qfall[lineEnd:]
    if (lineStart < 2)
        let qfnew = qfall[lineEnd:]
    endif

    call setqflist(qfnew, 'r')
    call winrestview(l:winview)
    call setpos('.', curpos)
endfunction

function! removeqfitem#FilterQF(isVisualMode) abort
    let curpos = getpos('.')
    let word = ""
    let l:winview = winsaveview()

    if (a:isVisualMode)
        let word = l9#getSelectedText()
    else
        let word = expand("<cword>")
    endif

    let promptString = 'Filter entries with text: '
    let word = input(promptString, word)
    if (empty(word))
        return
    endif

    let filename = expand("%")
    if (len(filename) > 0)
        delete " current line
        return
    endif

    let qfall = getqflist()
    call filter(qfall, 'v:val.text !~ "'.word.'" && bufname(v:val.bufnr) !~ "'.word.'"')
    call setqflist(qfall, 'r')
    call winrestview(l:winview)
    call setpos('.', curpos)
endfunction
