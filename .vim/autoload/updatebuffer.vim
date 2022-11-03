" update current file
function! updatebuffer#UpdateBuffer(force) abort
    let winview = winsaveview()
    if (a:force) | e! | else | e | endif
    call winrestview(winview)
endfunction
