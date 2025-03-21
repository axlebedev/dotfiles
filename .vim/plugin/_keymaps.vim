vim9script

import 'vim-js-fastlog.vim' as jsLog
import 'chase.vim' as chase

import autoload '../autoload/globalfind.vim'
import autoload '../autoload/opennextbuf.vim'
import autoload '../autoload/htmlbeautify.vim'
import autoload '../autoload/increasefoldlevel.vim'
import autoload '../autoload/logfunction.vim'
import autoload '../autoload/removeqfitem.vim'
import autoload './updatebuffer.vim'
import autoload './quickfix-utils.vim' as quickfixUtils

g:mapleader = "\<space>"

nmap <Tab> %<CMD>FindCursor 0 500<CR>
vmap <Tab> %

# Avoid accidental hits of <F1> while aiming for <Esc>
map  <F1> <CMD>Helptags<cr>
imap <F1> <Esc>

# Make moving in line a bit more convenient
nnoremap <silent> gg <ScriptCmd>cursor(1, 1)<CR>
nnoremap $ g_
vnoremap $ g_
onoremap $ g_
nnoremap $$ $
vnoremap $$ $
onoremap $$ $
nnoremap 0 ^
vnoremap 0 ^
onoremap 0 ^
nnoremap 00 0
vnoremap 00 0
onoremap 00 0
nnoremap f; g_
vnoremap f; g_
onoremap f; g_

# fast save file, close file
nnoremap <leader>w <CMD>w!<cr>

# Если просто закрыть fugitive-буфер - то закроется весь вим.
# Поэтому делаем такой костыль
augroup dont_close_fugitive
    autocmd!
    # By default it's set bufhidden=delete in plugin source. I dont need it
    autocmd BufReadPost fugitive://* set bufhidden&
augroup END
def CloseBuffer()
    var buf = bufnr('%')
    var filesLength = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    echom 'filesLength=' .. filesLength
    if (filesLength <= 1)
        if (&ft == 'startify')
            qa!
        else
            Startify
        endif
    else
        bprev
    endif
    exe 'bdelete ' .. buf

    if (&buftype ==# 'quickfix' || &buftype ==# 'terminal')
        Startify
    endif
enddef
nmap <silent> <leader>q <ScriptCmd>CloseBuffer()<CR>

# new empty buffer
noremap <leader>x <CMD>Startify<cr>

# split line
nnoremap <leader>s a<CR><Esc>

# comfortable navigation through windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

# visual select last visual selection
# ХЗ почему я постоянно путаю
nnoremap vg gv

# visual select last pasted text
nnoremap vp `[v`]

# NERDTree mappings
map <F2> <CMD>NERDTreeToggle<CR>
nnoremap <leader>tt <CMD>NERDTreeFind<CR>

# repeat command for each line in selection
xnoremap . <CMD>normal .<CR>

# don't reset visual selection after indent
xnoremap <silent> > >gv
xnoremap <silent> < <gv

# Movement in wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

# insert blank line
nnoremap <leader>o o<Esc>

# save file under root
cmap w!! w !sudo tee % >/dev/null

# replace selection
vnoremap <C-h> "hy:%s/<C-r>h//gc<left><left><left><C-r>h

# pretty find
vnoremap // "py/<C-R>p<CR>

# close all other buffers
nnoremap bo <CMD>BufOnly<CR>

# Now we don't have to move our fingers so far when we want to scroll through
# the command history; also, don't forget the q: command
cnoremap <c-j> <down>
cnoremap <c-k> <up>

# dont insert annoying 'PrtSc' code
inoremap <t_%9> <nop>

# Resize submode
g:submode_always_show_submode = 1
g:submode_timeout = 0
var resizeSubmode = 'Resize'
submode#enter_with(resizeSubmode, 'n', '', '<C-r>')
submode#map(resizeSubmode, 'n', '', 'h', ':vertical resize -1<cr>')
submode#map(resizeSubmode, 'n', '', 'l', ':vertical resize +1<cr>')
submode#map(resizeSubmode, 'n', '', 'k', ':resize -1<cr>')
submode#map(resizeSubmode, 'n', '', 'j', ':resize +1<cr>')

var foldlevelSubmode = 'Foldlevel'
submode#enter_with(foldlevelSubmode, 'n', '', '<leader>fo')
submode#map(foldlevelSubmode, 'n', '', '-', '<ScriptCmd>call increasefoldlevel#decreaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '<', '<ScriptCmd>call increasefoldlevel#decreaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', 'h', '<ScriptCmd>call increasefoldlevel#decreaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '+', '<ScriptCmd>call increasefoldlevel#increaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '>', '<ScriptCmd>call increasefoldlevel#increaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', 'l', '<ScriptCmd>call increasefoldlevel#increaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '0', '<ScriptCmd>setlocal foldlevel=0<cr>')
submode#map(foldlevelSubmode, 'n', '', '9', '<ScriptCmd>setlocal foldlevel=99<cr>')

autocmd au_vimrc FileType help,qf,git,fugitive* nnoremap <buffer> q <CMD>q<cr>

nnoremap <silent> <leader>a <CMD>ArgWrap<CR>

nnoremap rr <Plug>(coc-codeaction-selected) | redraw
vnoremap rr <Plug>(coc-codeaction-selected) | redraw
def LeaderT(isVMode = false)
    if (&buftype == 'quickfix')
        wincmd k
    endif
    if (&filetype == 'nerdtree')
        wincmd l
    endif
    fzf#vim#files('', {
        source: 'ag --vimgrep --hidden --ignore node_modules --ignore dist  --ignore .git --ignore .ccls-cache -l',
        sink: 'e',
        options: isVMode ? '--query=' .. tolower(substitute(@l, '\.', '', '')) : ''
    })
enddef
nnoremap <silent> <leader>t <ScriptCmd>LeaderT()<CR>
vnoremap <silent> <leader>t "ly<ScriptCmd>LeaderT(true)<CR>
nnoremap <silent> <leader>b <CMD>Buffers<CR>
# FZF command
nnoremap <silent> sft <CMD>Filetypes<CR>
nnoremap <silent> <leader>h <CMD>History<CR>
nnoremap <silent> <C-p> <CMD>Commands<CR>

nnoremap <silent> <leader>r <Plug>(refactor-commands)

# get current highlight group under cursor
map <F10> <ScriptCmd>echo 'hi<' .. synID(line('.'), col('.'), 1)->synIDattr('name') .. '> '
            \ .. 'transparent<' .. synID(line('.'), col('.'), 0)->synIDattr('name') .. '>'
            \ .. ' lo<' .. synID(line('.'), col('.'), 1)->synIDtrans()->synIDattr('name') .. '>'<CR>

nnoremap Y y$
vmap p pgvy
# replace word under cursor with last yanked
nnoremap wp mmviwpgvy`m
nnoremap <silent> p p`]

# I dont need ex mode
nnoremap Q @@

# beautify json, need "sudo apt install jq"
nnoremap <leader>bj <CMD>%!jq .<cr>
vnoremap <leader>bj <CMD>'<,'>!jq .<cr>
# beautify html
nnoremap <leader>bh <ScriptCmd>htmlbeautify.Htmlbeautify()<CR>

def ClapOpen(command_str: string)
  while (winnr('$') > 1 && (expand('%') =~# 'NERD_tree' || &ft == 'help' || &ft == 'qf'))
    wincmd w
  endwhile
  exe 'normal! ' .. command_str .. "\<cr>"
enddef

nnoremap <silent> <leader>j <ScriptCmd>ClapOpen(':vim9cmd opennextbuf.OpenNextBuf(1)')<CR>
nnoremap <silent> <leader>k <ScriptCmd>ClapOpen(':vim9cmd opennextbuf.OpenNextBuf(0)')<CR>

nnoremap <leader>f <CMD>FindCursor #CC0000 500<CR>

# Global find fix: use 'ag' and open quickfix {{{
nnoremap <C-f> <ScriptCmd>globalfind.Grep()<CR>
vnoremap <C-f> <ScriptCmd>globalfind.Grep()<CR>

nnoremap <C-f><C-t> <ScriptCmd>globalfind.FilterTestEntries()<cr>
nnoremap <C-f><C-d> <ScriptCmd>quickfixUtils.DeduplicateQuickfixList()<cr>

# jsLog.JsFastLog mapping {{{
nnoremap <leader>l <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_simple')<cr>g@
vnoremap <leader>l <ScriptCmd>jsLog.JsFastLog_simple(visualmode())<cr>

nnoremap <leader>ll <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_JSONstringify')<cr>g@
vnoremap <leader>ll <ScriptCmd>jsLog.JsFastLog_JSONstringify(visualmode())<cr>

nnoremap <leader>lk <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_variable')<cr>g@
nmap <leader>lkk <leader>lkiW
vnoremap <leader>lk <ScriptCmd>jsLog.JsFastLog_variable(visualmode())<cr>

nmap <leader>ltk <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_variable_trace')<cr>g@iW
nmap <leader>lts <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_string_trace')<cr>g@iW
vnoremap <leader>lt <ScriptCmd>jsLog.JsFastLog_variable_trace(visualmode())<cr>

nnoremap <leader>ld <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_function')<cr>g@
vnoremap <leader>ld <ScriptCmd>jsLog.JsFastLog_function(visualmode())<cr>

nnoremap <leader>ls <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_string')<cr>g@
vnoremap <leader>ls <ScriptCmd>jsLog.JsFastLog_string(visualmode())<cr>

nnoremap <leader>lss <ScriptCmd>jsLog.JsFastLog_separator()<cr>
nnoremap <leader>lsn <ScriptCmd>jsLog.JsFastLog_lineNumber()<cr>
# }}}

nnoremap <silent> K <CMD>call CocAction("doHover")<CR>
def JumpDefinitionFindCursor(command: string)
    setreg('/', expand('<cword>'))
    exe "call CocAction('" .. command .. "')"
    timer_start(100, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
def GoToDef()
    if (expand('<cword>') == 'import')
        keepjumps search('from')
        keepjumps normal! Wl
        JumpDefinitionFindCursor('jumpDefinition')
        return
    endif
    var single_letter = getline('.')[col('.') - 1]
    while (single_letter == ' ' || single_letter == '<')
        normal! w
        single_letter = getline('.')[col('.') - 1]
    endwhile

    var savedCursor = getcurpos()
    JumpDefinitionFindCursor('jumpImplementation')
    if (savedCursor == getcurpos())
        JumpDefinitionFindCursor('jumpDefinition')
    endif
enddef
nnoremap gd <ScriptCmd>GoToDef()<CR>
nnoremap gt <ScriptCmd>JumpDefinitionFindCursor('jumpTypeDefinition')<CR>

def ToggleQuickFix()
    if getwininfo()->filter((id, info) => info.quickfix)->empty()
        copen
    else
        cclose
    endif
enddef
nnoremap <silent> co <ScriptCmd>ToggleQuickFix()<CR>

noremap <silent> <plug>(slash-after) <CMD>execute("FindCursor #d6d8fa 0<bar>ShowSearchIndex")<CR>

# этот момент заебал
cnoremap <C-f> <NOP>

nnoremap <BS> ==
vnoremap <BS> =

nnoremap <silent> x "_x
# Для того чтобы поменять местами буквы - оставляем дефолтное поведение
nnoremap xp xp

vnoremap SB <Plug>VSurroundBkJ
vnoremap Sb <Plug>VSurroundbkJ

def EslintFile()
    read !npx eslint --fix %
    updatebuffer.UpdateBuffer(1)
enddef
nnoremap <silent> elf <ScriptCmd>EslintFile()<CR>

nnoremap ~ <ScriptCmd>chase.Next()<CR>
vnoremap ~ <ScriptCmd>chase.Next()<CR>
nnoremap ! <ScriptCmd>chase.Prev()<CR>
vnoremap ! <ScriptCmd>chase.Prev()<CR>

nnoremap q <NOP>
nnoremap <C-q> q

def FoldSelection()
  var saved = &foldmethod
  exe 'setlocal foldmethod=manual'
  normal! zf
enddef
vnoremap zf <ScriptCmd>FoldSelection()<CR>

nnoremap lf <ScriptCmd>logfunction.LogFunction()<CR>

nnoremap ZC zC
nnoremap ZO zO

nnoremap H zc

def RefUsed(cleanImports: bool)
    const word = expand('<cword>')
    setreg('/', word)
    execute "normal \<Plug>(coc-references-used)"
    if (cleanImports)
        var DoCleanImports = () => {
            if (&ft == 'qf')
                removeqfitem.FilterQFWithWord('import')
                removeqfitem.FilterQFWithWord('\<\/')
            else
                # timer_start(100, (id) => DoCleanImports())
            endif
        } 
        timer_start(300, (id) => DoCleanImports())
    endif
enddef
# nmap <silent>gr <Plug>(coc-references-used)
nmap <silent>gr <ScriptCmd>RefUsed(true)<CR>
nmap <silent>grr <ScriptCmd>RefUsed(false)<CR>

# Yank with keeping cursor position in visual mode {{{
def Keepcursor_visual_wrapper(command: string)
  execute 'normal! gv' .. command
  execute "normal! gv\<ESC>"
enddef
xnoremap <silent> y :<C-u>call <SID>Keepcursor_visual_wrapper('y')<CR>
xnoremap <silent> Y :<C-u>call <SID>Keepcursor_visual_wrapper('Y')<CR>
# }}}

# Repeat on every line {{{
# repeat last command for each line of a visual selection
vnoremap . :normal .<CR>
# replay @q macro for each line of a visual selection
vnoremap @q :normal @q<CR>
vnoremap @@ :normal @@<CR>
# }}}
#

nnoremap U <C-r>

# select in function by coc.nvim
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)

# select in class by coc.nvim
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
