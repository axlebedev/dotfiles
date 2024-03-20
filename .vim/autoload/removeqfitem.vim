vim9script

import autoload './globalfind.vim'

# When using in the quickfix list, remove the item from the quickfix list.
export def RemoveQFItem()
    var filename = expand("%")
    if (len(filename) > 0)
        delete # current line
        return
    endif

    var curpos = getpos('.')
    var winview = winsaveview()
    var qfall = getqflist()
    var curqfidx = line('.') - 1

    remove(qfall, curqfidx)
    setqflist(qfall, 'r')
    winrestview(winview)
    setpos('.', curpos)
enddef

export def RemoveQFItemsVisual()
    var curpos = getpos('.')
    var vpos = getpos('v')
    var lineStart = min([curpos[1], vpos[1]])
    var lineEnd = max([curpos[1], vpos[1]])

    var filename = expand("%")
    if (len(filename) > 0)
        deletebufline(bufname(''), lineStart, lineEnd)
        return
    endif

    var winview = winsaveview()
    var qfall = getqflist()

    var qfnew = lineStart < 2
        ? qfall[lineEnd : ]
        : qfall[ : lineStart - 2] + qfall[lineEnd : ]

    setqflist(qfnew, 'r')
    winrestview(winview)
    execute 'normal! ' .. lineStart .. 'G'
    execute 'normal! ' .. mode()
enddef

export def FilterQF(isVisualMode: bool)
    var initialWord = isVisualMode ? l9#getSelectedText() : expand("<cword>")

    var word = input('Filter entries with text: ', initialWord)
    if (empty(word))
        return
    endif

    var curpos = getpos('.')
    var winview = winsaveview()

    var filename = expand("%")
    if (len(filename) > 0)
        delete # current line
        return
    endif

    var qfall = getqflist()
    filter(
        qfall,
        'v:val.text !~? "' .. word .. '" && bufname(v:val.bufnr) !~? "' .. word .. '"',
    )
    setqflist(qfall, 'r')
    winrestview(winview)
    setpos('.', curpos)

    globalfind.ResizeQFHeight()
enddef
