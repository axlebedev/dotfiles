" Delete trailing white space
function! trailingspace#DeleteTrailingWS() abort
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunction
