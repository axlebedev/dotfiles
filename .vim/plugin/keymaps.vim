let mapleader = "\<space>"
nmap <space> <leader>
vmap <space> <leader>
xmap <space> <leader>

" Jump to matching pairs easily, with Tab
" NOTE: recursive map for macros/matchit.vim
nmap <Tab> %:<C-u>call findcursor#FindCursor(0, 0)<CR>
vmap <Tab> %

" Avoid accidental hits of <F1> while aiming for <Esc>
map  <F1> :<C-u>Helptags<cr>
imap <F1> <Esc>

" Make moving in line a bit more convenient
" NOTE: maps twice: Nnoremap and Vnoremap
nnoremap 0 ^
nnoremap ^ 0
nnoremap 00 0
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

" fast save file, close file
nnoremap <leader>w :w!<cr>
nmap <silent> <leader>q :<C-u>call kwbd#Kwbd(1)<CR>

" new empty buffer
noremap <leader>x :Startify<cr>

" split line
nnoremap <leader>s a<CR><Esc>

" comfortable navigation through windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" double-space to enter command-line
nnoremap <Space><Space> :

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

" insert blank line
nnoremap <leader>o o<Esc>

" save file under root
cmap w!! w !sudo tee % >/dev/null

" replace selection
vnoremap <C-h> "hy:%s/<C-r>h//gc<left><left><left><C-r>h

" pretty find
vnoremap // "py/<C-R>p<CR>

" add a symbol to current line
nnoremap <silent> <leader>; :call appendchar#AppendChar(';')<CR>
nnoremap <silent> <leader>, :call appendchar#AppendChar(',')<CR>

" close all other buffers
nnoremap bo :BufOnly<CR>

" Now we don't have to move our fingers so far when we want to scroll through
" the command history; also, don't forget the q: command
cnoremap <c-j> <down>
cnoremap <c-k> <up>

" dont insert annoying 'PrtSc' code
inoremap <t_%9> <nop>

" Resize submode
let g:submode_always_show_submode = 1
let g:submode_timeout = 0
let resizeSubmode = 'Resize'
call submode#enter_with(resizeSubmode, 'n', '', '<M-r>')
call submode#enter_with(resizeSubmode, 'n', '', '<leader>r')
call submode#map(resizeSubmode, 'n', '', 'h', ':vertical resize -1<cr>')
call submode#map(resizeSubmode, 'n', '', 'l', ':vertical resize +1<cr>')
call submode#map(resizeSubmode, 'n', '', 'k', ':resize -1<cr>')
call submode#map(resizeSubmode, 'n', '', 'j', ':resize +1<cr>')

" uncomment next line on join if it's comment
" NOTE: need Plug 'tomtom/tcomment_vim'
nnoremap J :normal jg<ck<CR>J

autocmd au_vimrc FileType help,qf,git nnoremap <buffer> q :q<cr>
autocmd au_vimrc FileType help,qf,git nnoremap <buffer> <Esc> :q<cr>

nnoremap <silent> <leader>a :<C-u>ArgWrap<CR>

function! ClapOpen(command_str)
  while (winnr('$') > 1 && (expand('%') =~# 'NERD_tree' || &ft == 'help' || &ft == 'qf'))
    wincmd w
  endwhile
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction

nnoremap <silent> <leader>t :call ClapOpen(':Clap files ++finder=git ls-files --cached --others --exclude-standard --exclude=!*local*')<CR>
nnoremap <silent> <leader>b :call ClapOpen(':Clap providers')<CR>

" get current highlight group under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap yf :call yankfilename#YankFileName()<CR>

nnoremap Y y$
vmap p pgvy
" replace word under cursor with last yanked
nnoremap wp mmviwpgvy`m
nnoremap <silent> p p`]

" fix one-line 'if' statement
nnoremap <silent> <leader>hh :call blockline#BlockLine()<CR>

" quickfix next
nnoremap <silent> cn :<C-u>cn<CR>

" return to start point on visual mode leave
nnoremap v vmv
nnoremap V Vmv
nnoremap <C-v> <C-v>mv
xnoremap <Esc> <Esc>`v

" for convenient git
nnoremap <C-g><C-g> :<C-u>Magit<CR>
nnoremap <C-g><C-b> :<C-u>Gblame<cr>
nnoremap <C-g><C-s> :<C-u>Gstatus<cr>
nnoremap <C-g><C-v> :<C-u>GV<cr>
" stage current file
nnoremap <C-g><C-w> :<C-u>Gw<cr> 

" beautify json
nnoremap <leader>bj :<C-u>%!python -m json.tool<cr>
" beautify html
nnoremap <leader>bh :<C-u>call htmlbeautify#htmlbeautify()<CR>

" copen
nnoremap <leader>co :<C-u>copen<cr>

nnoremap <leader>c :call readmode#ReadModeToggle()<cr>

nnoremap <silent> <leader>j :call ClapOpen(':call opennextbuf#OpenNextBuf(1)')<CR>
nnoremap <silent> <leader>k :call ClapOpen(':call opennextbuf#OpenNextBuf(0)')<CR>

nnoremap <leader>f :<C-u>call findcursor#FindCursor(1, 1)<CR>

" update current file
function! UpdateBuffer(force) abort
    let winview = winsaveview()
    if (a:force) | e! | else | e | endif
    call winrestview(winview)
endfunction
nnoremap <silent> <F5> :call UpdateBuffer(0)<CR>
nnoremap <silent> <F5><F5> :call UpdateBuffer(1)<CR>

nnoremap <c-f><c-f> :<C-u>call globalfind#EsearchWord()<CR>
nnoremap <c-f> :<C-u>call globalfind#Esearch()<CR>
xnoremap <c-f> :<C-u>call globalfind#EsearchVisual()<CR>
nnoremap <C-f><C-t> :call globalfind#FilterTestEntries()<cr>

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

" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

nnoremap <silent> K :call CocAction("doHover")<CR>
nnoremap <silent> gd :call CocAction("jumpDefinition")<CR>

nnoremap <silent> gdd :call gdd#gdd()<CR>

nnoremap <silent> to :call openjstest#OpenJsTest()<cR>

nnoremap <silent> co :cope<CR>

noremap <silent> <plug>(slash-after) :execute("FindCursor<bar>ShowSearchIndex")<CR>
