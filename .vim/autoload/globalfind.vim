" find word under cursor
set grepprg=ag\ --vimgrep\ --hidden\ --smart-case\ --ignore\ node_modules\ --ignore\ dist
" cnoremap <C-w> <CMD>set grepprg=ag\ --vimgrep\ --hidden\ --smart-case\ --ignore\ node_modules\ --ignore\ dist\ --word-regexp<CR>
" cnoremap <C-W> <CMD>set grepprg=ag\ --vimgrep\ --hidden\ --smart-case\ --ignore\ node_modules\ --ignore\ dist<CR>

function! globalfind#Grep(...)
    let word = input('Search: ', expand('<cword>'))
    if (mode() != 'n')
        " visual selection
        let word = getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]]
    endif

    let expandedArgs= expandcmd(join(a:000, ' '))
    let @/ = word
    cgetexpr system(join([&grepprg] + [expandedArgs] + [word], ' '))
    copen
endfunction

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

" =============================================================================

function! globalfind#FilterTestEntries() abort
    let list = getqflist()
    let filtered = copy(list)
                \ ->filter("bufname(v:val.bufnr) !~# 'node_modules'")
                " \ ->filter('index(list, v:val, v:key+1)==-1') " remove duplicates
                \ ->filter("bufname(v:val.bufnr) !~# 'test__'")
                \ ->filter("bufname(v:val.bufnr) !~# 'git'")
                \ ->filter("bufname(v:val.bufnr) !~# 'diff'")
                \ ->filter("bufname(v:val.bufnr) !~# 'commonMock'")
                \ ->filter("bufname(v:val.bufnr) !~# 'yarn.lock'")
                \ ->filter("bufname(v:val.bufnr) !~# 'package-lock.json'")
                \ ->filter("bufname(v:val.bufnr) !~# 'fake-api'")
                \ ->filter("bufname(v:val.bufnr) !~# 'crowdin'")
                \ ->filter("bufname(v:val.bufnr) !~# 'localization'")
    call setqflist(filtered)
endfunction
