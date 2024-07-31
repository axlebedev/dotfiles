vim9script

import 'vim-js-fastlog.vim' as jsLog
import 'chase.vim' as chase

import autoload '../autoload/globalfind.vim'
import autoload '../autoload/opennextbuf.vim'
import autoload '../autoload/appendchar.vim'
import autoload '../autoload/blockline.vim'
import autoload '../autoload/htmlbeautify.vim'
import autoload '../autoload/readmode.vim'
import autoload '../autoload/updatebuffer.vim'
import autoload '../autoload/yankfilename.vim'
import autoload '../autoload/increasefoldlevel.vim'
import autoload '../autoload/requiretoimport.vim'

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

# add a symbol to current line
nnoremap <silent> <leader>; <ScriptCmd>appendchar.AppendChar(';')<CR>
nnoremap <silent> <leader>, <ScriptCmd>appendchar.AppendChar(',')<CR>

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
submode#map(foldlevelSubmode, 'n', '', '-', '<ScriptCmd>call increasefoldlevel#decreaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '<', '<ScriptCmd>call increasefoldlevel#decreaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', 'h', '<ScriptCmd>call increasefoldlevel#decreaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '+', '<ScriptCmd>call increasefoldlevel#increaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '>', '<ScriptCmd>call increasefoldlevel#increaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', 'l', '<ScriptCmd>call increasefoldlevel#increaseFoldlevel()<cr>')
submode#map(foldlevelSubmode, 'n', '', '0', '<ScriptCmd>set foldlevel=0<cr>')
submode#map(foldlevelSubmode, 'n', '', '9', '<ScriptCmd>set foldlevel=99<cr>')

autocmd au_vimrc FileType help,qf,git,fugitive* nnoremap <buffer> q <CMD>q<cr>

nnoremap <silent> <leader>a <CMD>ArgWrap<CR>

def ClapOpen(command_str: string)
  while (winnr('$') > 1 && (expand('%') =~# 'NERD_tree' || &ft == 'help' || &ft == 'qf'))
    wincmd w
  endwhile
  exe 'normal! ' .. command_str .. "\<cr>"
enddef

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
nnoremap <silent> <leader>m <CMD>call fzf#vim#files('', {
            \    'source': 'git diff --name-only --diff-filter=U',
            \    'sink': 'e',
            \    'options': '--prompt="Unmerged> "'
            \ })<CR>
# FZF command
nnoremap <silent> sft <CMD>Filetypes<CR>
nnoremap <silent> <leader>h <CMD>History<CR>
nnoremap <silent> <C-p> <CMD>Commands<CR>

def g:GeditFile(branch: string)
    execute 'Gedit ' .. branch .. ':%'
enddef
# open current file version in branch
nnoremap <silent> <C-g><C-f> <ScriptCmd>fzf#run(fzf#wrap({ source: 'sh ~/dotfiles/fish/sortedBranch.sh', sink: g:GeditFile }))<CR>
# open unmerged list
nnoremap <silent> <C-g><C-m> <CMD>fzf#run({'source': 'git diff --name-only --diff-filter=U', 'sink': 'e', 'window': { 'width': 0.9, 'height': 0.6 }})<CR>

# get current highlight group under cursor
map <F10> <CMD>echo "hi<" .. synIDattr(synID(line("."),col("."),1),"name") .. '> trans<'
\ .. synIDattr(synID(line("."),col("."),0),"name") .. "> lo<"
\ .. synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .. ">"<CR>

nnoremap yf <ScriptCmd>yankfilename.YankFileName()<CR>
nnoremap yg <ScriptCmd>yankfilename.YankGithubURL()<CR>

nnoremap Y y$
vmap p pgvy
# replace word under cursor with last yanked
nnoremap wp mmviwpgvy`m
nnoremap <silent> p p`]

# I dont need ex mode
nnoremap Q @@

# fix one-line 'if' statement
nnoremap <silent> <leader>hh <ScriptCmd>blockline.BlockLine()<CR>

# quickfix next
def Cn()
    Cnext
    # it should run after buffer change
    timer_start(1, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
nnoremap <silent> cn <ScriptCmd>Cn()<CR>
# quickfix prev
def Cp()
    Cprev
    # it should run after buffer change
    timer_start(1, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
nnoremap <silent> cp <ScriptCmd>Cp()<CR>

# for convenient git
nnoremap <C-g><C-g> <CMD>Magit<CR>
nnoremap <C-g><C-b> <CMD>Git blame<cr>
nnoremap <C-g><C-v> <CMD>GV!<cr>
# stage current file
nnoremap <C-g><C-w> <CMD>Gw<cr> 

# beautify json, need "sudo apt install jq"
nnoremap <leader>bj <CMD>%!jq .<cr>
vnoremap <leader>bj <CMD>'<,'>!jq .<cr>
# beautify html
nnoremap <leader>bh <ScriptCmd>htmlbeautify.Htmlbeautify()<CR>

nnoremap <leader>c <ScriptCmd>readmode.ReadModeToggle()<cr>

nnoremap <silent> <leader>j <ScriptCmd>ClapOpen(':vim9cmd opennextbuf.OpenNextBuf(1)')<CR>
nnoremap <silent> <leader>k <ScriptCmd>ClapOpen(':vim9cmd opennextbuf.OpenNextBuf(0)')<CR>

nnoremap <leader>f <CMD>FindCursor #CC0000 500<CR>

nnoremap <silent> <F5> <ScriptCmd>updatebuffer.UpdateBuffer(0)<CR>
nnoremap <silent> <F5><F5> <ScriptCmd>updatebuffer.UpdateBuffer(1)<CR>

# Global find fix: use 'ag' and open quickfix {{{
nnoremap <C-f> <ScriptCmd>globalfind.Grep()<CR>
vnoremap <C-f> <ScriptCmd>globalfind.Grep()<CR>

nnoremap <C-f><C-t> <ScriptCmd>globalfind.FilterTestEntries()<cr>

# jsLog.JsFastLog mapping
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

nnoremap <silent> K <CMD>call CocAction("doHover")<CR>
def JumpDefinitionFindCursor(command: string)
    exe "call CocAction('" .. command .. "')"
    timer_start(100, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
nnoremap gd <ScriptCmd>JumpDefinitionFindCursor('jumpDefinition')<CR>
nnoremap gt <ScriptCmd>JumpDefinitionFindCursor('jumpTypeDefinition')<CR>
nnoremap gi <ScriptCmd>JumpDefinitionFindCursor('jumpImplementation')<CR>

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
    updatebuffer.UpdateBuffer(1)
enddef
nnoremap <silent> elf <ScriptCmd>Elf()<CR>

nnoremap ~ <ScriptCmd>chase.Next()<CR>
vnoremap ~ <ScriptCmd>chase.Next()<CR>
nnoremap ! <ScriptCmd>chase.Prev()<CR>
vnoremap ! <ScriptCmd>chase.Prev()<CR>

nnoremap zn nzz

nnoremap q <NOP>
nnoremap <C-q> q

vmap " S"
vmap ' S'
vmap ( S(
vmap ) S)
vmap [ S[
vmap ] S]
vmap { S{
vmap _ S_

# wrap visual selection into function block 
vnoremap <C-b> "bdi{<CR>return <C-r>b;<CR>}<Esc>=ib

def FoldSelection()
  var saved = &foldmethod
  &foldmethod = 'manual'
  normal! zf
enddef
vnoremap zf <ScriptCmd>FoldSelection()<CR>

nnoremap rti <ScriptCmd>requiretoimport.RequireToImport()<CR>
nnoremap itr <ScriptCmd>requiretoimport.ImportToRequire()<CR>

nnoremap ZC zC
nnoremap ZO zO

nnoremap H zc
