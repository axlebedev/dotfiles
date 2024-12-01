vim9script

# toggle centering cursor
# NOTE: scrolloff can't be local :(
var scrolloff_value = &scrolloff
var isReadmodeEnabled = 0

export def ReadmodeToggle()
    if (isReadmodeEnabled)
        SetReadmode(false)
    else 
        SetReadmode(true)
    endif
enddef

export def ReadmodeEnable()
    SetReadmode(true)
enddef

export def ReadmodeDisable()
    SetReadmode(false)
enddef

def SetReadmode(setEnabled: bool)
    if (setEnabled)
        isReadmodeEnabled = 1
        scrolloff_value = &scrolloff
        set scrolloff=999
        set virtualedit=all

        var curPos = getpos('.')
        curPos[2] = 100
        setpos('.', curPos)
    else 
        isReadmodeEnabled = 0
        &scrolloff = scrolloff_value
        set virtualedit=block
    endif
enddef

command! ReadmodeEnable ReadmodeEnable()
command! ReadmodeDisable ReadmodeDisable()
command! ReadmodeToggle ReadmodeToggle()

nnoremap <leader>c <ScriptCmd>ReadmodeToggle()<cr>
