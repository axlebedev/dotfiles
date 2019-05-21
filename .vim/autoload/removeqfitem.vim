" When using in the quickfix list, remove the item from the quickfix list.
function! removeqfitem#RemoveQFItem() abort
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
