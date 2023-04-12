" Scroll/cursor bind the current window and the previous window. 
" TODO: fix it (сейчас если поскроллить - то они разъедутся)
command! BindBoth set scrollbind cursorbind | wincmd p | set scrollbind cursorbind | wincmd p
command! BindBothOff set noscrollbind nocursorbind | wincmd p | set noscrollbind nocursorbind | wincmd p

" Show all TODO's in directory
command! Todo call todo#Todo()

" type ':S<cr>' to split current buffer to right, and leave it with previous buffer
command! S vs | wincmd h | bprev | wincmd l

command! Grc Git rebase --continue

command! NewInstance !gnome-terminal -- vim %

" Make cnext and co wrap
command! Cnext try | cnext | catch | cfirst | catch | endtry
command! Cprev try | cprev | catch | clast | catch | endtry

command! Lnext try | lnext | catch | lfirst | catch | endtry
command! Lprev try | lprev | catch | llast | catch | endtry

command! ClearSession %bd | NERDTree | wincmd l | Startify

let s:FindCursorPostSaved = g:FindCursorPost
function! NullFn() abort
endfunction
function! SetDemoMode(on) abort
    if (a:on == 1)
        FootprintsDisable
        ALEDisable
        let s:FindCursorPostSaved = g:FindCursorPost
        let g:FindCursorPost = function('NullFn')
    else
        FootprintsEnable
        ALEEnable
        let g:FindCursorPost = s:FindCursorPostSaved
    endif
endfunction

command! DemoOn call SetDemoMode(1)
command! DemoOff call SetDemoMode(0)

" run buffer
function! RB() abort
    silent normal! gg"yyG
    @y<CR>
endfunction
command! RB call RB()
