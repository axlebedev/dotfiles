function! yankfilename#YankFileName()
    let filename = expand("%:.") . ':' . line('.')
    let @* = filename
    let @+ = filename
    echo 'yanked: "' . filename . '"'
endfunction
