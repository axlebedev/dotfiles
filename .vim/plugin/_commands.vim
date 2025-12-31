vim9script

import autoload '../autoload/showmapping.vim'

# Scroll/cursor bind the current window and the previous window. 
# TODO: fix it (сейчас если поскроллить - то они разъедутся)
command! BindBoth set scrollbind cursorbind | wincmd p | set scrollbind cursorbind | wincmd p
command! BindBothOff set noscrollbind nocursorbind | wincmd p | set noscrollbind nocursorbind | wincmd p

# type ':S<cr>' to split current buffer to right, and leave it with previous buffer
command! S vs | wincmd h | bprev | wincmd l

# command! NewInstance !gnome-terminal -- vim %
command! NewInstance !gnome-terminal -- vim %

# Make cnext and co wrap
command! Cnext try | cnext | catch | cfirst | catch | endtry
command! Cprev try | cprev | catch | clast | catch | endtry

command! Lnext try | lnext | catch | lfirst | catch | endtry
command! Lprev try | lprev | catch | llast | catch | endtry

var FindCursorPostSaved: func
def SetDemoMode(on: bool)
    if (on)
        FootprintsDisable
        ALEDisable
        FindCursorPostSaved = g:FindCursorPost
        g:FindCursorPost = () => null
    else
        FootprintsEnable
        ALEEnable
        g:FindCursorPost = FindCursorPostSaved
    endif
enddef

command! DemoOn SetDemoMode(1)
command! DemoOff SetDemoMode(0)

def RunWinNew()
    var fname = expand("%")
    silent exec "!gnome-terminal -- vim " .. fname .. " > /dev/null"
    redraw!
enddef
command! WinNew RunWinNew()

# Create commands for common mapping types
command! -nargs=1 MapQf call showmapping.ShowMappingsInQuickfix('map ' .. <q-args>)
