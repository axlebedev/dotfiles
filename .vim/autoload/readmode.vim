vim9script

# toggle centering cursor
# NOTE: scrolloff can't be local :(
var scrolloff_value = &scrolloff
var isReadModeEnabled = 0

export def ReadModeToggle()
    if (isReadModeEnabled)
        SetReadMode(false)
    else 
        SetReadMode(true)
    endif
enddef

export def ReadModeEnable()
    SetReadMode(true)
enddef

export def ReadModeDisable()
    SetReadMode(false)
enddef

def SetReadMode(setEnabled: bool)
    if (setEnabled)
        isReadModeEnabled = 1
        scrolloff_value = &scrolloff
        set scrolloff=999
        set virtualedit=all

        var curPos = getpos('.')
        curPos[2] = 100
        setpos('.', curPos)
    else 
        isReadModeEnabled = 0
        &scrolloff = scrolloff_value
        set virtualedit=block
    endif
enddef
