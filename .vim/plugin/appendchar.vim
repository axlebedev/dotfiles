vim9script

# append a char
def AppendChar(char: string)
    var cursor_pos = getpos(".")

    var text = substitute(
        getline('.'),
        '\v^(.*\S)(\s*)$',
        '\1' .. char .. '\2',
        ''
    )
    setline('.', text)

    setpos('.', cursor_pos)
enddef

# add a symbol to current line
nnoremap <silent> <leader>; <ScriptCmd>AppendChar(';')<CR>
nnoremap <silent> <leader>, <ScriptCmd>AppendChar(',')<CR>
