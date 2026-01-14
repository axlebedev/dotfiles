vim9script

var ignored = [
    'dist',
    'package-lock.json',
    'yarn.lock',
    'dist',
    '.git',
    'stats.json',
    '.ccls-cache',
    '.tmp',
]

const ignoredList = ignored->map((_, val) => '--iglob !' .. val)->join(' ')
# find word under cursor
# const basegrepprg = 'rg --hidden --no-heading -N ' .. ignoredList
const basegrepprg = 'rg --hidden --no-heading --with-filename --line-number -H ' .. ignoredList

const charsForEscape = '*'
# -w --word-regexp
var isWholeWord = 0
# -Q --literal
var isLiteral = 0
# case
# -i --ignore-case        Match case insensitively
# -s --case-sensitive     Match case sensitively
# -S --smart-case         Match case insensitively unless PATTERN contains
#                         uppercase characters (Enabled by default)
var caseArray = ['--smart-case', '-i', '-s']
var case = caseArray[0]

&grepprg = basegrepprg

var popupId = 0

def CaseToString(): string
    if (case == caseArray[1])
        return '－'
    elseif (case == caseArray[2])
        return '➕'
    endif
    return 'S'
enddef

def MakeVarsString(): string
    return 'w' .. (isWholeWord % 2 ? '➕' : '－') .. ' l' .. (isLiteral % 2 ? '➕' : '－') .. ' i' .. CaseToString() .. ' Search>'
enddef

export def ResizeQFHeight(): void
    var qfLength = getqflist()->len()
    if (qfLength == 0)
        return
    endif
    execute 'resize ' .. min([
        qfLength + 1,
        &lines / 2, # &lines - full height of vim window
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

def IncCase(): string
    var nextCaseIndex = (caseArray->index(case) + 1) % caseArray->len()
    case = caseArray[nextCaseIndex]
    popup_settext(popupId, MakeVarsString())
    redraw
    return ''
enddef

export def Grep()
    cmap <C-w> <C-r>=<sid>IncWord()<cr>
    cmap <C-l> <C-r>=<sid>IncLiteral()<cr>
    cmap <C-i> <C-r>=<sid>IncCase()<cr>

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
    # Waiting for user input...
    popup_close(popupId)
    var savedIsLiteral = isLiteral
    if (!isLiteral && word =~ escape(charsForEscape, charsForEscape))
        IncLiteral()
    endif

    if (!empty(word))
        isWholeWord = isWholeWord % 2
        isLiteral = isLiteral % 2
        word = isLiteral ? shellescape(word) : escape(word, charsForEscape)
        setreg('/', word)

        var prg = basegrepprg
        if (isWholeWord)
            prg = prg .. ' -w'
        endif
        if (isLiteral)
            prg = prg .. ' -F'
        endif
        prg = prg .. ' ' .. case

        cgetexpr system(join(
            [prg, '"' .. word .. '"', '.'], 
            ' '
        ))
        copen
        ResizeQFHeight()
    endif

    isLiteral = savedIsLiteral
    cunmap <C-w>
    cunmap <C-l>
    cunmap <C-i>
    redraw # ensure popup_close is on screen
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
                \ ->filter("bufname(v:val.bufnr) !~# 'Tests'")
                \ ->filter("bufname(v:val.bufnr) !~# 'QtEditor'")
                \ ->filter("bufname(v:val.bufnr) !~# '\-\-'")
    setqflist(filtered)
    ResizeQFHeight()
enddef
