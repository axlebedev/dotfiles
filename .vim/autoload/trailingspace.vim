vim9script

# Delete trailing white space
export def DeleteTrailingWS()
    var cursor_pos = getpos(".")

    :%s/\s\+$//ge

    setpos('.', cursor_pos)
enddef
