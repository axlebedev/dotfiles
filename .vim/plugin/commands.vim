" Scroll/cursor bind the current window and the previous window. 
" TODO: fix it (сейчас если поскроллить - то они разъедутся)
command! BindBoth set scrollbind cursorbind | wincmd p | set scrollbind cursorbind | wincmd p
command! BindBothOff set noscrollbind nocursorbind | wincmd p | set noscrollbind nocursorbind | wincmd p

" Show all TODO's in directory
command! Todo call todo#Todo()

" type ':S<cr>' to split current buffer to right, and leave it with previous buffer
command! S vs | wincmd h | bprev | wincmd l

command! Grc Git rebase --continue
