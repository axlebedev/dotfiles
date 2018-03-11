" toggle centering cursor
" NOTE: scrolloff can't be local :(
let s:scrolloff_value = &scrolloff
function! readmode#ReadModeToggle() abort
    if &scrolloff > 10
        let &scrolloff = s:scrolloff_value
        set virtualedit=block
    else 
        let s:scrolloff_value = &scrolloff
        set scrolloff=999
        set virtualedit=all
    endif
endfunction
