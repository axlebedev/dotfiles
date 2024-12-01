vim9script

# make single-line code to blocked
def BlockSingleLineIf()
    cursor(line('.'), 1)
    search('if')
    normal! f(%l"dDA {
    normal! o
    normal! "dp==o}
enddef

# make single-line code to blocked
def BlockSingleLineFunc()
    cursor(line('.'), 1)
    # 'e'	move to the End of the match
    search('=>', 'e')
    execute "normal! a {\n}"
    normal! lDO
    normal! p==
enddef

def BlockLine()
    var currentLine = line('.')
    cursor(currentLine, 1)
    # 'n'	do Not move the cursor
    var hasIf = search('if', 'nc', currentLine) == currentLine
    if (hasIf)
        BlockSingleLineIf()
        return
    endif

    var hasFunc = search('=>', 'nc', currentLine) == currentLine
    if (hasFunc)
        BlockSingleLineFunc()
        return
    endif
enddef

# fix one-line 'if' statement
nnoremap <silent> <leader>hh <ScriptCmd>BlockLine()<CR>
