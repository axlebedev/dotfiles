" find word under cursor

function! globalfind#FilterTestEntries() abort
    let filtered0 = filter(getqflist(), "bufname(v:val.bufnr) !~# 'test'")
    let filtered1 = filter(filtered0, "bufname(v:val.bufnr) !~# 'jsfiller3'")
    let filtered2 = filter(filtered1, "bufname(v:val.bufnr) !~# 'git'")
    let filtered3 = filter(filtered2, "bufname(v:val.bufnr) !~# 'diff'")
    let filtered4 = filter(filtered3, "bufname(v:val.bufnr) !~# 'commonMock'")
    let filtered5 = filter(filtered4, "bufname(v:val.bufnr) !~# 'yarn.lock'")
    call setqflist(filtered5)
endfunction
