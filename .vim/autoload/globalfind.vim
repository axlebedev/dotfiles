" find word under cursor

function! globalfind#FilterTestEntries() abort
    let filtered = getqflist()
                \ ->filter("bufname(v:val.bufnr) !~# 'test'")
                \ ->filter("bufname(v:val.bufnr) !~# 'git'")
                \ ->filter("bufname(v:val.bufnr) !~# 'diff'")
                \ ->filter("bufname(v:val.bufnr) !~# 'commonMock'")
                \ ->filter("bufname(v:val.bufnr) !~# 'yarn.lock'")
                \ ->filter("bufname(v:val.bufnr) !~# 'fake-api'")
                \ ->filter("bufname(v:val.bufnr) !~# 'crowdin'")
                \ ->filter("bufname(v:val.bufnr) !~# 'localization'")
                \ ->filter("bufname(v:val.bufnr) !~# 'node_modules'")
    call setqflist(filtered)
endfunction
