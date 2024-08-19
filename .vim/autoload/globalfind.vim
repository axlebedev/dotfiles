vim9script

var ignored = [
    'node_modules',
    'dist',
    'package-lock.json',
    'yarn.lock',
    'dist',
    '.git',
    'stats.json',
    '.ccls-cache',
    '.tmp',
]
var ignoredList = map(ignored, (_, val) => '--ignore ' .. val)->join(' ')
# find word under cursor
var basegrepprg = 'ag --hidden --smart-case ' .. ignoredList
# -w --word-regexp
var isWholeWord = 0
# -Q --literal
var isLiteral = 0
&grepprg = basegrepprg

var popupId = 0

def MakeVarsString(): string
    return 'w' .. (isWholeWord % 2 ? '➕' : '－') .. ' l' .. (isLiteral % 2 ? '➕' : '－') .. ' Search>'
enddef

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
    normal! zb
enddef

def IncWord(): string
    isWholeWord += 1
    popup_settext(popupId, MakeVarsString())
    redraw
    return ''
enddef

def IncLiteral(): string
    isLiteral += 1
    popup_settext(popupId, MakeVarsString())
    redraw
    return ''
enddef

export def Grep()
    cmap <C-w> <C-r>=<sid>IncWord()<cr>
    cmap <C-l> <C-r>=<sid>IncLiteral()<cr>

    var initialWord = mode() != 'n'
        ? l9#getSelectedText()
        : expand('<cword>')

    var varsString = MakeVarsString()
    popupId = popup_create(varsString, {
        pos: 'botleft',
        col: 1,
        line: 1000,
    })
    redraw

    var word = input(repeat(' ', varsString->strwidth()), initialWord)

    popup_close(popupId)

    if (!empty(word))
        setreg('/', word)
        isWholeWord = isWholeWord % 2
        isLiteral = isLiteral % 2

        var prg = basegrepprg
        if (isWholeWord)
            prg = prg .. ' --word-regexp'
        endif
        if (isLiteral)
            prg = prg .. ' --literal'
        endif
        cgetexpr system(join(
            [prg] + ['"' .. word .. '"', '.'], 
            ' '
        ))
        copen
        ResizeQFHeight()
    endif

    cunmap <C-w>
    cunmap <C-l>
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
                \ ->filter("bufname(v:val.bufnr) !~# 'amr-docs'")
                \ ->filter("bufname(v:val.bufnr) !~# 'test'")
    setqflist(filtered)
    ResizeQFHeight()
enddef
