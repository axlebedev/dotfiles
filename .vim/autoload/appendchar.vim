vim9script

# append a char
export def AppendChar(char: string)
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
