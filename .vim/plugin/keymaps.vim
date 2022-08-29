let mapleader = "\<space>"
nmap <space> <leader>
vmap <space> <leader>
xmap <space> <leader>

" Jump to matching pairs easily, with Tab
" NOTE: recursive map for macros/matchit.vim
nmap <Tab> %<CMD>FindCursor 0 500<CR>
vmap <Tab> %

" Avoid accidental hits of <F1> while aiming for <Esc>
map  <F1> <CMD>Helptags<cr>
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

" fast save file, close file
nnoremap <leader>w <CMD>w!<cr>

" Если просто закрыть fugitive-буфер - то закроется весь вим.
" Поэтому делаем такой костыль
function! s:DontCloseFugitive() abort
    set bufhidden&
endfunction

" By default it's set bufhidden=delete in plugin source. I dont need it
augroup dont_close_fugitive
    autocmd!
    autocmd BufReadPost fugitive://* call <SID>DontCloseFugitive()
augroup END
function s:CloseBuffer() abort
    let buf = bufnr('%')
    let filesLength = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    if (filesLength == 1)
        Startify
    else
        b#
    endif
    exe 'bdelete '.buf
endfunction
nmap <silent> <leader>q <CMD>call <SID>CloseBuffer()<CR>

" new empty buffer
noremap <leader>x <CMD>Startify<cr>

" split line
nnoremap <leader>s a<CR><Esc>

" comfortable navigation through windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" visual select last visual selection
" ХЗ почему я постоянно путаю
nnoremap vg gv

" visual select last pasted text
nnoremap vp `[v`]

" NERDTree mappings
map <F2> <CMD>NERDTreeToggle<CR>
nnoremap <leader>tt <CMD>NERDTreeFind<CR>

" repeat command for each line in selection
xnoremap . <CMD>normal .<CR>

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
nnoremap <silent> <leader>; <CMD>call appendchar#AppendChar(';')<CR>
nnoremap <silent> <leader>, <CMD>call appendchar#AppendChar(',')<CR>

" close all other buffers
nnoremap bo <CMD>BufOnly<CR>

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

autocmd au_vimrc FileType help,qf,git,fugitive* nnoremap <buffer> q <CMD>q<cr>

nnoremap <silent> <leader>a <CMD>ArgWrap<CR>

function! ClapOpen(command_str)
  while (winnr('$') > 1 && (expand('%') =~# 'NERD_tree' || &ft == 'help' || &ft == 'qf'))
    wincmd w
  endwhile
  exe 'normal! ' . a:command_str . "\<cr>"
endfunction

" nnoremap <silent> <leader>t <CMD>GFiles -c -o --exclude-standard<CR>

nnoremap <silent> <leader>t <CMD>call fzf#vim#gitfiles('', {
            \    'source': 'git ls-files -c -o --exclude-standard ',
            \    'sink': 'e'
            \ })<CR>
vnoremap <silent> <leader>t "ly<CMD>call fzf#vim#gitfiles('', {
            \    'source': 'git ls-files -c -o --exclude-standard ',
            \    'sink': 'e',
            \    'options': '--query='.tolower(substitute(@l, '\.', '', ''))
            \ })<CR>
nnoremap <silent> <leader>b <CMD>Buffers<CR>
nnoremap <silent> <leader>m <CMD>call fzf#vim#gitfiles('', {
            \    'source': 'git diff --name-only --diff-filter=U',
            \    'sink': 'e',
            \    'options': '--prompt="Unmerged> "'
            \ })<CR>
" FZF command
nnoremap <silent> <leader>h <CMD>History<CR>

function! g:GeditFile(branch) abort
    execute 'Gedit '.a:branch.':%'
endfunction
" open current file version in branch
nnoremap <silent> <C-g><C-f> <CMD>call fzf#run(fzf#wrap({ 'source': 'sh ~/dotfiles/fish/sortedBranch.sh', 'sink': function('GeditFile') }))<CR>
" open unmerged list
nnoremap <silent> <C-g><C-m> <CMD>call fzf#run({'source': 'git diff --name-only --diff-filter=U', 'sink': 'e', 'window': { 'width': 0.9, 'height': 0.6 }})<CR>

" get current highlight group under cursor
map <F10> <CMD>echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap yf <CMD>call yankfilename#YankFileName()<CR>
nnoremap yg <CMD>call yankfilename#YankGithubURL()<CR>

nnoremap Y y$
vmap p pgvy
" replace word under cursor with last yanked
nnoremap wp mmviwpgvy`m
nnoremap <silent> p p`]

" I dont need ex mode
nnoremap Q @@

" fix one-line 'if' statement
nnoremap <silent> <leader>hh <CMD>call blockline#BlockLine()<CR>

" quickfix next
function! Cn() abort
    Cnext
    " it should run after buffer change
    call timer_start(1, {id -> findcursor#FindCursor('#d6d8fa', 0)})
endfunction
nnoremap <silent> cn <CMD>call Cn()<CR>
" quickfix prev
function! Cp() abort
    Cprev
    " it should run after buffer change
    call timer_start(1, {id -> findcursor#FindCursor('#d6d8fa', 0)})
endfunction
nnoremap <silent> cp <CMD>call Cp()<CR>

" for convenient git
nnoremap <C-g><C-g> <CMD>Magit<CR>
nnoremap <C-g><C-b> <CMD>Git blame<cr>
nnoremap <C-g><C-v> <CMD>GV<cr>
" stage current file
nnoremap <C-g><C-w> <CMD>Gw<cr> 

" beautify json, need "sudo apt install jq"
nnoremap <leader>bj <CMD>%!jq .<cr>
vnoremap <leader>bj <CMD>'<,'>!jq .<cr>
" beautify html
nnoremap <leader>bh <CMD>call htmlbeautify#htmlbeautify()<CR>

nnoremap <leader>c <CMD>call readmode#ReadModeToggle()<cr>

nnoremap <silent> <leader>j <CMD>call ClapOpen(':call opennextbuf#OpenNextBuf(1)')<CR>
nnoremap <silent> <leader>k <CMD>call ClapOpen(':call opennextbuf#OpenNextBuf(0)')<CR>

nnoremap <leader>f <CMD>FindCursor #CC0000 500<CR>

" update current file
function! UpdateBuffer(force) abort
    let winview = winsaveview()
    if (a:force) | e! | else | e | endif
    call winrestview(winview)
endfunction
nnoremap <silent> <F5> <CMD>call UpdateBuffer(0)<CR>
nnoremap <silent> <F5><F5> <CMD>call UpdateBuffer(1)<CR>

map <c-f> <plug>(esearch)
nnoremap <C-f><C-t> <CMD>call globalfind#FilterTestEntries()<cr>

" JsFastLog mapping
nnoremap <leader>l <CMD>set operatorfunc=JsFastLog_simple<cr>g@
vnoremap <leader>l <CMD>call JsFastLog_simple(visualmode())<cr>

nnoremap <leader>ll <CMD>set operatorfunc=JsFastLog_JSONstringify<cr>g@
vnoremap <leader>ll <CMD>call JsFastLog_JSONstringify(visualmode())<cr>

nnoremap <leader>lk <CMD>set operatorfunc=JsFastLog_variable<cr>g@
nmap <leader>lkk <leader>lkiW
vnoremap <leader>lk <CMD>call JsFastLog_variable(visualmode())<cr>

nnoremap <leader>ld <CMD>set operatorfunc=JsFastLog_function<cr>g@
vnoremap <leader>ld <CMD>call JsFastLog_function(visualmode())<cr>

nnoremap <leader>ls <CMD>set operatorfunc=JsFastLog_string<cr>g@
vnoremap <leader>ls <CMD>call JsFastLog_string(visualmode())<cr>

nnoremap <leader>lpp <CMD>set operatorfunc=JsFastLog_prevToThis<cr>g@
vnoremap <leader>lpp <CMD>call JsFastLog_prevToThis(visualmode())<cr>

nnoremap <leader>lpn <CMD>set operatorfunc=JsFastLog_thisToNext<cr>g@
vnoremap <leader>lpn <CMD>call JsFastLog_thisToNext(visualmode())<cr>

nnoremap <leader>lss <CMD>call JsFastLog_separator()<cr>
nnoremap <leader>lsn <CMD>call JsFastLog_lineNumber()<cr>

" nnoremap <silent> K <CMD>call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd <CMD>call LanguageClient#textDocument_definition()<CR>

nnoremap <silent> K <CMD>call CocAction("doHover")<CR>
function! JumpDefinitionFindCursor() abort
    call CocAction("jumpDefinition")
    " call timer_start(100, {id -> findcursor#FindCursor('#68705e', 0)})
    call timer_start(100, {id -> findcursor#FindCursor('#d6d8fa', 0)})

endfunction
nnoremap <silent> gd <CMD>call JumpDefinitionFindCursor()<CR>

nnoremap <silent> gdd <CMD>call gdd#gdd()<CR>

nnoremap <silent> to <CMD>call openjstest#OpenJsTest()<cR>

nnoremap <silent> co <CMD>cope<CR>

noremap <silent> <plug>(slash-after) <CMD>execute("FindCursor #d6d8fa 0<bar>ShowSearchIndex")<CR>
" 'quickfix next'
nnoremap <silent> qn <CMD>execute("cnext<bar>normal n")<CR>

" этот момент заебал
cnoremap <C-f> <NOP>

nnoremap zj zz<CMD>execute 'normal '.(winheight('.') / 4).'<C-e>'<CR>

nnoremap <BS> ==
vnoremap <BS> =

nnoremap <silent> x "_x
" Для того чтобы поменять местами буквы - оставляем дефолтное поведение
nnoremap xp xp

nnoremap sft :<C-U>setfiletype 
