let mapleader = "\<space>"
nmap <space> <leader>
vmap <space> <leader>
xmap <space> <leader>

" fast open/reload vimrc
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Jump to matching pairs easily, with Tab
" NOTE: recursive map for macros/matchit.vim
nmap <Tab> %
vmap <Tab> %

" Avoid accidental hits of <F1> while aiming for <Esc>
map  <F1> <Esc>
imap <F1> <Esc>

" Make moving in line a bit more convenient
" NOTE: maps twice: Nnoremap and Vnoremap
nnoremap 0 ^
nnoremap ^ 0
nnoremap 00 0
nnoremap $ g_
nnoremap $$ $
nnoremap H ^
nnoremap HH 0
nnoremap L g_
nnoremap LL $
vnoremap 0 ^
vnoremap ^ 0
vnoremap 00 0
vnoremap $ g_
vnoremap $$ $
vnoremap H ^
vnoremap HH 0
vnoremap L g_
vnoremap LL $

" fast save file, close file
nnoremap <leader>w :w!<cr>
nmap <silent> <leader>q :<C-u>call kwbd#Kwbd(1)<CR>

" new empty buffer
noremap <leader>x :Startify<cr>

" split line
nnoremap <leader>s a<CR><Esc>

" use K to join current line with line above, just like J does with line below
nnoremap K kJ

" comfortable navigation through windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" double-space to enter command-line
nnoremap <Space><Space> :

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" visual select current line
nnoremap vl ^vg_

" visual select last visual selection
" ХЗ почему я постоянно путаю
nnoremap vg gv

" NERDTree mappings
map <F2> :NERDTreeToggle<CR>
nnoremap <leader>tt :NERDTreeFind<CR>

" repeat command for each line in selection
xnoremap . :normal .<CR>

" don't reset visual selection after indent
xnoremap <silent> > >gv
xnoremap <silent> < <gv

" Movement in wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" toggle fold on tripleclick
noremap <3-LeftMouse> za

" insert blank line
nnoremap <leader>o o<Esc>

" save file under root
cmap w!! w !sudo tee % >/dev/null

" replace selection
vnoremap <C-h> "hy:%s/<C-r>h//gc<left><left><left><C-r>h

" visual select all
nnoremap <M-a> ggVG

" pretty find
vnoremap // "py/<C-R>p<CR>

" add a symbol to current line
nnoremap <silent> <leader>; :call appendchar#AppendChar(';')<CR>
nnoremap <silent> <leader>, :call appendchar#AppendChar(',')<CR>

" Toggle true/false
nnoremap <silent> <C-t> :<C-u>ToggleBool<CR>

" toggle foldColumn: 0->6->12->0...
nnoremap <silent> <F4> :let &l:foldcolumn = (&l:foldcolumn + 6) % 18<cr>

" close all other buffers
nnoremap bo :BufOnly<CR>

" Now we don't have to move our fingers so far when we want to scroll through
" the command history; also, don't forget the q: command
cnoremap <c-j> <down>
cnoremap <c-k> <up>

" dont insert annoying 'PrtSc' code
inoremap <t_%9> <nop>

" <C-v> in insertmode to paste
inoremap <C-v> <C-r>*

" Resize submode
let g:submode_always_show_submode = 1
let g:submode_timeout = 0
let resizeSubmode = 'Resize'
call submode#enter_with(resizeSubmode, 'n', '', '<M-r>')
call submode#map(resizeSubmode, 'n', '', 'h', ':vertical resize -1<cr>')
call submode#map(resizeSubmode, 'n', '', 'l', ':vertical resize +1<cr>')
call submode#map(resizeSubmode, 'n', '', 'k', ':resize -1<cr>')
call submode#map(resizeSubmode, 'n', '', 'j', ':resize +1<cr>')

autocmd au_vimrc FileType help,qf,git nnoremap <buffer> q :q<cr>
autocmd au_vimrc FileType help,qf,git nnoremap <buffer> <Esc> :q<cr>

nnoremap <silent> <leader>a :<C-u>ArgWrap<CR>
nnoremap <silent> <leader>t :<C-u>CtrlP<CR>

" get current highlight group under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap <M-o> <Tab>

nnoremap zl :set foldlevel=1<cr>

nnoremap <silent> <leader>hh :call blockline#BlockLine()<CR>

" for convenient git
nnoremap <C-g> :<C-u>Magit<CR>
nnoremap <C-g><C-b> :<C-u>Gblame<cr>
nnoremap <C-g><C-s> :<C-u>Gstatus<cr>
nnoremap <C-g><C-v> :<C-u>GV<cr>

" beautify json
nnoremap <leader>bj :<C-u>%!python -m json.tool<cr>

nnoremap <leader>c :call readmode#ReadModeToggle()<cr>

nnoremap <leader>j :<C-u>call opennextbuf#OpenNextBuf(1)<CR>
nnoremap <leader>k :<C-u>call opennextbuf#OpenNextBuf(0)<CR>

nnoremap <silent> <F3> :call google#Google(expand("<cword>"))<cr>
xnoremap <silent> <F3> "gy:call google#Google(@g)<cr>gv

" update current file
nnoremap <silent> <F5> :e<CR>

nnoremap <C-f> :call globalfind#GlobalFind(0, 0, 0)<cr>
xnoremap <C-f> :call globalfind#GlobalFind(1, 0, 0)<cr>
nnoremap <C-f><C-f> :call globalfind#GlobalFind(0, 1, 0)<cr>
xnoremap <C-f><C-f> :call globalfind#GlobalFind(1, 1, 0)<cr>
nnoremap <C-f><C-r> :call globalfind#GlobalFind(0, 0, 1)<cr>
xnoremap <C-f><C-r> :call globalfind#GlobalFind(1, 0, 1)<cr>
nnoremap <C-f><C-t> :call globalfind#ToggleTestSearch()<cr>
xnoremap <C-f><C-t> :call globalfind#ToggleTestSearch()<cr>

" JsFastLog mapping
nnoremap <leader>l :set operatorfunc=JsFastLog_simple<cr>g@
vnoremap <leader>l :<C-u>call JsFastLog_simple(visualmode())<cr>

nnoremap <leader>ll :set operatorfunc=JsFastLog_JSONstringify<cr>g@
vnoremap <leader>ll :<C-u>call JsFastLog_JSONstringify(visualmode())<cr>

nnoremap <leader>lk :set operatorfunc=JsFastLog_variable<cr>g@
nmap <leader>lkk <leader>lkiW
vnoremap <leader>lk :<C-u>call JsFastLog_variable(visualmode())<cr>

nnoremap <leader>ld :set operatorfunc=JsFastLog_function<cr>g@
vnoremap <leader>ld :<C-u>call JsFastLog_function(visualmode())<cr>

nnoremap <leader>ls :set operatorfunc=JsFastLog_string<cr>g@
vnoremap <leader>ls :<C-u>call JsFastLog_string(visualmode())<cr>

nnoremap <leader>lpp :set operatorfunc=JsFastLog_prevToThis<cr>g@
vnoremap <leader>lpp :<C-u>call JsFastLog_prevToThis(visualmode())<cr>

nnoremap <leader>lpn :set operatorfunc=JsFastLog_thisToNext<cr>g@
vnoremap <leader>lpn :<C-u>call JsFastLog_thisToNext(visualmode())<cr>

nnoremap <leader>lss :call JsFastLog_separator()<cr>
nnoremap <leader>lsn :call JsFastLog_lineNumber()<cr>

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
