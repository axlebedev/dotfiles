" find word under cursor

function! globalfind#FilterTestEntries() abort
    let filtered = filter(getqflist(), "bufname(v:val.bufnr) !~# 'test'")
    let filtered = filter(filtered, "bufname(v:val.bufnr) !~# 'jsfiller3'")
    let filtered = filter(filtered, "bufname(v:val.bufnr) !~# 'git'")
    let filtered = filter(filtered, "bufname(v:val.bufnr) !~# 'diff'")
    let filtered = filter(filtered, "bufname(v:val.bufnr) !~# 'commonMock'")
    let filtered = filter(filtered, "bufname(v:val.bufnr) !~# 'yarn.lock'")
    let filtered = filter(filtered, "bufname(v:val.bufnr) !~# 'fake-api'")
    let filtered = filter(filtered, "bufname(v:val.bufnr) !~# 'crowdin'")
    let filtered = filter(filtered, "bufname(v:val.bufnr) !~# 'localization'")
    call setqflist(filtered)
endfunction
