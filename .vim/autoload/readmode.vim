" toggle centering cursor
" NOTE: scrolloff can't be local :(
let s:scrolloff_value = &scrolloff
let s:isReadModeEnabled = 0

function! readmode#ReadModeToggle() abort
    if s:isReadModeEnabled
        call s:SetReadMode(0)
    else 
        call s:SetReadMode(1)
    endif
endfunction

function! readmode#ReadModeEnable() abort
    call s:SetReadMode(1)
endfunction

function! readmode#ReadModeDisable() abort
    call s:SetReadMode(0)
endfunction

function! s:SetReadMode(setEnabled) abort
    if (a:setEnabled)
        let s:isReadModeEnabled = 1
        let s:scrolloff_value = &scrolloff
        set scrolloff=999
        set virtualedit=all

        let curPos = getpos('.')
        let curPos[2] = 100
        call setpos('.', curPos)
    else 
        let s:isReadModeEnabled = 0
        let &scrolloff = s:scrolloff_value
        set virtualedit=block
    endif
endfunction
