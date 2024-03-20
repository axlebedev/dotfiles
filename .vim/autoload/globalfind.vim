vim9script

# find word under cursor
set grepprg=ag\ --hidden\ --smart-case\ --ignore\ node_modules\ --ignore\ dist\ --ignore\ .git\ --ignore\ stats.json\ --ignore\ .ccls-cache
# -w --word-regexp
# -Q --literal

export def ResizeQFHeight(): void
    var qfLength = getqflist()->len()
    if (qfLength == 0)
        return
    endif
    resize 1000
    var fullHeight = winheight(winnr())
    execute 'resize ' .. min([
        qfLength + 1,
        fullHeight / 2,
    ])
enddef

export def Grep()
    var initialWord = mode() != 'n'
        ? l9#getSelectedText()
        : expand('<cword>')

    var word = input('Search: ', initialWord)

    if (!empty(word))
        setreg('/', word)
        cgetexpr system(join([&grepprg] + ['"' .. word .. '"', '.'], ' '))
        copen
        ResizeQFHeight()
    endif
enddef

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

# =============================================================================

export def FilterTestEntries()
    var list = getqflist()
    var filtered = copy(list)
                \ ->filter("bufname(v:val.bufnr) !~# 'node_modules'")
                \ ->filter("bufname(v:val.bufnr) !~# 'package-lock.json'")
                \ ->filter("bufname(v:val.bufnr) !~# 'test__'")
                \ ->filter("bufname(v:val.bufnr) !~# 'git'")
                \ ->filter("bufname(v:val.bufnr) !~# 'diff'")
                \ ->filter("bufname(v:val.bufnr) !~# 'commonMock'")
                \ ->filter("bufname(v:val.bufnr) !~# 'yarn.lock'")
                \ ->filter("bufname(v:val.bufnr) !~# 'fake-api'")
                \ ->filter("bufname(v:val.bufnr) !~# 'api-types'")
                \ ->filter("bufname(v:val.bufnr) !~# 'crowdin'")
                \ ->filter("bufname(v:val.bufnr) !~# 'localization'")
                \ ->filter("bufname(v:val.bufnr) !~# 'dictionaries'")
                \ ->filter("bufname(v:val.bufnr) !~# 'spec.ts'")
                \ ->filter("bufname(v:val.bufnr) !~# 'spec.js'")
                \ ->filter("bufname(v:val.bufnr) !~# 'amrDocs'")
    setqflist(filtered)
    ResizeQFHeight()
enddef
