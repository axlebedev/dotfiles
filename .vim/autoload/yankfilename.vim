function! yankfilename#YankFileName()
    let filename = expand("%")
    let @* = filename
    let @+ = filename
    echo 'yanked: "' . filename . '"'
endfunction
