vim9script

import autoload '../autoload/globalfind.vim'
import autoload '../autoload/opennextbuf.vim'
import autoload '../autoload/appendchar.vim'
import autoload '../autoload/blockline.vim'
import autoload '../autoload/gdd.vim'

g:mapleader = "\<space>"
nmap <space> <leader>
vmap <space> <leader>
xmap <space> <leader>

# Jump to matching pairs easily, with Tab
# NOTE: recursive map for macros/matchit.vim
nmap <Tab> %<CMD>FindCursor 0 500<CR>
vmap <Tab> %

# Avoid accidental hits of <F1> while aiming for <Esc>
map  <F1> <CMD>Helptags<cr>
imap <F1> <Esc>

# Make moving in line a bit more convenient
# NOTE: maps twice: Nnoremap and Vnoremap
nnoremap 0 ^
nnoremap ^ 0
nnoremap 00 0
nnoremap <silent> gg <CMD>vim9cmd cursor(1, 1)<CR>
nnoremap $ g_
nnoremap $$ $
nnoremap L g_
nnoremap LL $
nnoremap f; g_

vnoremap 0 ^
vnoremap ^ 0
vnoremap 00 0
vnoremap $ g_
vnoremap $$ $
vnoremap H ^
vnoremap HH 0
vnoremap L g_
vnoremap LL $
vnoremap f; g_

onoremap 0 ^
onoremap ^ 0
onoremap 00 0
onoremap $ g_
onoremap $$ $
onoremap H ^
onoremap HH 0
onoremap L g_
onoremap LL $
onoremap f; g_

# fast save file, close file
nnoremap <leader>w <CMD>w!<cr>

# Если просто закрыть fugitive-буфер - то закроется весь вим.
# Поэтому делаем такой костыль
def DontCloseFugitive()
    set bufhidden&
enddef

# By default it's set bufhidden=delete in plugin source. I dont need it
augroup dont_close_fugitive
    autocmd!
    autocmd BufReadPost fugitive://* <SID>DontCloseFugitive()
augroup END
def CloseBuffer()
    var buf = bufnr('%')
    var filesLength = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if (filesLength == 1)
        Startify
    else
        bprev
    endif
    exe 'bdelete ' .. buf
enddef
nmap <silent> <leader>q <CMD>vim9cmd <SID>CloseBuffer()<CR>

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

# add a symbol to current line
nnoremap <silent> <leader>; <CMD>vim9cmd <SID>appendchar.AppendChar(';')<CR>
nnoremap <silent> <leader>, <CMD>vim9cmd <SID>appendchar.AppendChar(',')<CR>

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
submode#enter_with(resizeSubmode, 'n', '', '<M-r>')
submode#enter_with(resizeSubmode, 'n', '', '<leader>r')
submode#map(resizeSubmode, 'n', '', 'h', ':vertical resize -1<cr>')
submode#map(resizeSubmode, 'n', '', 'l', ':vertical resize +1<cr>')
submode#map(resizeSubmode, 'n', '', 'k', ':resize -1<cr>')
submode#map(resizeSubmode, 'n', '', 'j', ':resize +1<cr>')

var foldlevelSubmode = 'Foldlevel'
submode#enter_with(foldlevelSubmode, 'n', '', '<leader>fo')
submode#map(foldlevelSubmode, 'n', '', '-', '<CMD>increasefoldlevel#decreaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '<', '<CMD>increasefoldlevel#decreaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', 'h', '<CMD>increasefoldlevel#decreaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '+', '<CMD>increasefoldlevel#increaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '>', '<CMD>increasefoldlevel#increaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', 'l', '<CMD>increasefoldlevel#increaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '0', '<CMD>set foldlevel=0<cr>')
submode#map(foldlevelSubmode, 'n', '', '9', '<CMD>set foldlevel=99<cr>')

autocmd au_vimrc FileType help,qf,git,fugitive* nnoremap <buffer> q <CMD>q<cr>

nnoremap <silent> <leader>a <CMD>ArgWrap<CR>

def ClapOpen(command_str: string)
  while (winnr('$') > 1 && (expand('%') =~# 'NERD_tree' || &ft == 'help' || &ft == 'qf'))
    wincmd w
  endwhile
  exe 'normal! ' .. command_str .. "\<cr>"
enddef

nnoremap <silent> <leader>t <CMD>call fzf#vim#files('', {
            \    'source': 'ag --vimgrep --hidden --ignore node_modules --ignore dist -l',
            \    'sink': 'e'
            \ })<CR>
vnoremap <silent> <leader>t "ly<CMD>call fzf#vim#files('', {
            \    'source': 'ag --vimgrep --hidden --ignore node_modules --ignore dist  -l',
            \    'sink': 'e',
            \    'options': '--query=' .. tolower(substitute(@l, '\.', '', ''))
            \ })<CR>
nnoremap <silent> <leader>b <CMD>Buffers<CR>
nnoremap <silent> <leader>m <CMD>call fzf#vim#files('', {
            \    'source': 'g diff --name-only --diff-filter=U',
            \    'sink': 'e',
            \    'options': '--prompt="Unmerged> "'
            \ })<CR>
# FZF command
nnoremap <silent> sft <CMD>Filetypes<CR>
nnoremap <silent> <leader>h <CMD>History<CR>
nnoremap <silent> <leader>e <CMD>Commands<CR>

def g:GeditFile(branch: string)
    execute 'Gedit ' .. branch .. ':%'
enddef
# open current file version in branch
nnoremap <silent> <C-g><C-f> <CMD>fzf#run(fzf#wrap({ 'source': 'sh ~/dotfiles/fish/sortedBranch.sh', 'sink': def('GeditFile') }))<CR>
# open unmerged list
nnoremap <silent> <C-g><C-m> <CMD>fzf#run({'source': 'git diff --name-only --diff-filter=U', 'sink': 'e', 'window': { 'width': 0.9, 'height': 0.6 }})<CR>

# get current highlight group under cursor
map <F10> <CMD>echo "hi<" .. synIDattr(synID(line("."),col("."),1),"name") .. '> trans<'
\ .. synIDattr(synID(line("."),col("."),0),"name") .. "> lo<"
\ .. synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .. ">"<CR>

nnoremap yf <CMD>call yankfilename#YankFileName()<CR>
nnoremap yg <CMD>call yankfilename#YankGithubURL()<CR>

nnoremap Y y$
vmap p pgvy
# replace word under cursor with last yanked
nnoremap wp mmviwpgvy`m
nnoremap <silent> p p`]

# I dont need ex mode
nnoremap Q @@

# fix one-line 'if' statement
nnoremap <silent> <leader>hh <CMD>vim9cmd <SID>blockline.BlockLine()<CR>

# quickfix next
def Cn()
    Cnext
    # it should run after buffer change
    timer_start(1, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
nnoremap <silent> cn <CMD>vim9cmd <SID>Cn()<CR>
# quickfix prev
def Cp()
    Cprev
    # it should run after buffer change
    timer_start(1, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
nnoremap <silent> cp <CMD>vim9cmd <SID>Cp()<CR>

# for convenient git
nnoremap <C-g><C-g> <CMD>Magit<CR>
nnoremap <C-g><C-b> <CMD>Git blame<cr>
nnoremap <C-g><C-v> <CMD>GV<cr>
# stage current file
nnoremap <C-g><C-w> <CMD>Gw<cr> 

# beautify json, need "sudo apt install jq"
nnoremap <leader>bj <CMD>%!jq .<cr>
vnoremap <leader>bj <CMD>'<,'>!jq .<cr>
# beautify html
nnoremap <leader>bh <CMD>call htmlbeautify#htmlbeautify()<CR>

nnoremap <leader>c <CMD>call readmode#ReadModeToggle()<cr>

nnoremap <silent> <leader>j <CMD>vim9cmd <SID>ClapOpen(':vim9cmd opennextbuf.OpenNextBuf(1)')<CR>
nnoremap <silent> <leader>k <CMD>vim9cmd <SID>ClapOpen(':vim9cmd opennextbuf.OpenNextBuf(0)')<CR>

nnoremap <leader>f <CMD>FindCursor #CC0000 500<CR>

nnoremap <silent> <F5> <CMD>call updatebuffer#UpdateBuffer(0)<CR>
nnoremap <silent> <F5><F5> <CMD>call updatebuffer#UpdateBuffer(1)<CR>

# Global find fix: use 'ag' and open quickfix {{{
nnoremap <C-f> <CMD>vim9cmd <SID>globalfind.Grep()<CR>
vnoremap <C-f> <CMD>vim9cmd <SID>globalfind.Grep()<CR>

nnoremap <C-f><C-t> <CMD>vim9cmd <SID>globalfind.FilterTestEntries()<cr>

# JsFastLog mapping
nnoremap <leader>l <CMD>set operatorfunc=JsFastLog_simple<cr>g@
vnoremap <leader>l <CMD>call JsFastLog_simple(visualmode())<cr>

nnoremap <leader>ll <CMD>set operatorfunc=JsFastLog_JSONstringify<cr>g@
vnoremap <leader>ll <CMD>call JsFastLog_JSONstringify(visualmode())<cr>

nnoremap <leader>lk <CMD>set operatorfunc=JsFastLog_variable<cr>g@
nmap <leader>lkk <leader>lkiW
vnoremap <leader>lk <CMD>call JsFastLog_variable(visualmode())<cr>

nnoremap <leader>ld <CMD>set operatorfunc=JsFastLog_def<cr>g@
vnoremap <leader>ld <CMD>call JsFastLog_def(visualmode())<cr>

nnoremap <leader>ls <CMD>set operatorfunc=JsFastLog_string<cr>g@
vnoremap <leader>ls <CMD>call JsFastLog_string(visualmode())<cr>

nnoremap <leader>lpp <CMD>set operatorfunc=JsFastLog_prevToThis<cr>g@
vnoremap <leader>lpp <CMD>call JsFastLog_prevToThis(visualmode())<cr>

nnoremap <leader>lpn <CMD>set operatorfunc=JsFastLog_thisToNext<cr>g@
vnoremap <leader>lpn <CMD>call JsFastLog_thisToNext(visualmode())<cr>

nnoremap <leader>lss <CMD>JsFastLog_separator()<cr>
nnoremap <leader>lsn <CMD>call JsFastLog_lineNumber()<cr>

# nnoremap <silent> K <CMD>call LanguageClient#textDocument_hover()<CR>
# nnoremap <silent> gd <CMD>call LanguageClient#textDocument_definition()<CR>

nnoremap <silent> K <CMD>call CocAction("doHover")<CR>
def JumpDefinitionFindCursor()
    exe "call CocAction('jumpDefinition')"
    # timer_start(100, {id -> findcursor#FindCursor('#68705e', 0)})
    timer_start(100, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
nnoremap gd <CMD>vim9cmd <SID>JumpDefinitionFindCursor()<CR>

nnoremap <silent> to <CMD>call openjstest#OpenJsTest()<cR>

nnoremap <silent> co <CMD>cope<CR>

noremap <silent> <plug>(slash-after) <CMD>execute("FindCursor #d6d8fa 0<bar>ShowSearchIndex")<CR>
# 'quickfix next'
nnoremap <silent> qn <CMD>execute("cnext<bar>normal n")<CR>

# этот момент заебал
cnoremap <C-f> <NOP>

nnoremap zj zz<CMD>execute 'normal ' .. (winheight('.') / 4) .. '<C-e>'<CR>

nnoremap <BS> ==
vnoremap <BS> =

nnoremap <silent> x "_x
# Для того чтобы поменять местами буквы - оставляем дефолтное поведение
nnoremap xp xp

nnoremap <C-;> <CMD>Commands<Cr>

vnoremap SB <Plug>VSurroundBkJ
vnoremap Sb <Plug>VSurroundbkJ

def Elf()
    read !npx eslint --fix %
    updatebuffer#UpdateBuffer(1)
enddef
nnoremap <silent> elf <CMD>vim9cmd <SID>Elf()<CR>
