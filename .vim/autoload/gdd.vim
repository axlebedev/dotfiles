" append a char
function! gdd#gdd() abort
    let curBufNum = bufname()
    call CocAction("jumpDefinition")
    execute 'bdelete '.curBufNum
endfunction
