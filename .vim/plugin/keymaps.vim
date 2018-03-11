let mapleader = "\<space>"
nmap <space> <leader>
vmap <space> <leader>
xmap <space> <leader>

" no noremap here!
nmap <leader>lkk <leader>lkiW

" fast open/reload vimrc
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Jump to matching pairs easily, with Tab
" NOTE: recursive map for macros/matchit.vim
nmap <Tab> %
vmap <Tab> %

" Avoid accidental hits of <F1> while aiming for <Esc>
map <F1> <Esc>
imap <F1> <Esc>

" Make moving in line a bit more convenient
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
nnoremap vg ^vg_

" Move a line of text using Ctrl+Alt+[jk]
nnoremap <C-M-j> mz:m+<cr>`z
nnoremap <C-M-k> mz:m-2<cr>`z
vnoremap <C-M-k> :m'<-2<cr>`>my`<mzgv`yo`z
vnoremap <C-M-j> :m'>+<cr>`<my`>mzgv`yo`z

" NERDTree mappings
map <F2> :NERDTreeToggle<CR>
nnoremap <leader>tt :NERDTreeFind<CR>

" apply macros with Q (disables the default Ex mode shortcut)
nnoremap Q @q
vnoremap Q :normal @q<CR>

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

" Also center the screen when jumping through the changelist
nnoremap g; g;zz
nnoremap g, g,zz

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
nnoremap <leader>; mqg_a;<esc>`q
nnoremap <leader>, mqg_a,<esc>`q

" Toggle true/false
nnoremap <silent> <C-t> mmviw:s/true\\|false/\={'true':'false','false':'true'}[submatch(0)]/<CR>`m:nohlsearch<CR>

" toggle foldColumn: 0->6->12->0...
nnoremap <silent> <F4> :let &l:foldcolumn = (&l:foldcolumn + 6) % 18<cr>

" close all other buffers
nnoremap bo :BufOnly<CR>

" Now we don't have to move our fingers so far when we want to scroll through
" the command history; also, don't forget the q: command
cnoremap <c-j> <down>
cnoremap <c-k> <up>

" some custom digraphs
digraphs TT 8869 " ⊥

" avoid mistypes :)
abbr funciton function
abbr cosnt const
abbr proips props
abbr setTimeou setTimeout
abbr setTimout setTimeout
abbr clearTimeou clearTimeout
abbr clearTimout clearTimeout
abbr widht width
abbr transfrom transform
abbr reutrn return
abbr retunr return

abbr pt PropTypes
abbr tp this.props
abbr ts this.state
abbr tc this.context
abbr np nextProps
abbr ns nextState

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

nnoremap <C-f> :call globalfind#GlobalFind(0, 0, 0)<cr>
xnoremap <C-f> :call globalfind#GlobalFind(1, 0, 0)<cr>
nnoremap <C-f><C-f> :call globalfind#GlobalFind(0, 1, 0)<cr>
xnoremap <C-f><C-f> :call globalfind#GlobalFind(1, 1, 0)<cr>
nnoremap <C-f><C-r> :call globalfind#GlobalFind(0, 0, 1)<cr>
xnoremap <C-f><C-r> :call globalfind#GlobalFind(1, 0, 1)<cr>
nnoremap <C-f><C-g> :call globalfind#ToggleGlobalFind()<cr>
xnoremap <C-f><C-g> :call globalfind#ToggleGlobalFind()<cr>
