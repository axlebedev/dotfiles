set synmaxcol=150 
set history=500
set gdefault
syntax on 
"for correct colorscheme work
set t_Co=256
set timeoutlen=300
colorscheme monokai
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta
let g:molokai_original = 1
"set background=dark
inoremap jj <Esc>
inoremap оо <Esc>

if has('gui_running')
 if has("win32") || has("win16")
  set guifont=Droid\ Sans\ Mono\ for\ Powerline\ P:h10
 else
  set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types\ 11
 endif
  set encoding=utf-8
  set fileencoding=utf-8
  set langmenu=en_US.UTF-8    " sets the language of the menu (gvim)
" language en                 " sets the language of the messages / ui (vim)
"  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=L  "remove left-hand scroll bar
endif

"nmap <C-w> tabclose
nnoremap <C-s> i<CR><Esc>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <Space><Space> :

"mouse for gnome-terminal
se mouse=a

"80 columns highlight
set cc=80

nnoremap <F12> :noh<CR>
nnoremap <C-Tab> :bn<CR>
nnoremap <C-S-Tab> :bp<CR>

"vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=234
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235

"let g:pathogen_disabled = ['tagbar']
filetype off
call pathogen#helptags()
call pathogen#infect()
filetype plugin indent on     
set omnifunc=syntaxcomplete#Complete

"Fix of Esc key while autocomplete popup is visible: return to Normal mode
let g:AutoClosePumvisible = {"ENTER": "\<C-y>", "Esc": "\<C-y>\<Esc>"}

au BufNewFile,BufRead *.{md,mdown,mkd,mkdn,markdown,mdwn} set     filetype=markdown

set ruler
set number
set showcmd
set tabstop=4
set shiftwidth=4
set smarttab
set hlsearch
set ignorecase
set smartcase
set path=.,,**

set ai "включим автоотступы для новых строк
set cin "отступы в стиле си

"NERD Comment
let mapleader = ","
nnoremap <leader>c<Space> <C-_>
nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>


"NERDTree
map <C-n> :NERDTreeTabsToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeShowHidden=1
let g:nerdtree_tabs_open_on_console_startup=1
let g:nerdtree_tabs_focus_on_files=1
let g:nerdtree_tabs_autofind=1

function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
	exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
	exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')

"airline
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif


let g:airline_left_sep = ''
let g:airline_right_sep = ''
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '◀'
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"tagbar
nmap <F8> :TagbarToggle<CR>

"ctrlP
let g:ctrlp_map = '<C-t>'
let g:ctrlp_cmd = 'CtrlP'


" Add support for markdown files in tagbar.
let g:tagbar_type_markdown = {
	\ 'ctagstype': 'markdown',
	\ 'ctagsbin' : '/home/alex/.vim/bundle/markdown2ctags/markdown2ctags.py',
	\ 'ctagsargs' : '-f - --sort=yes',
	\ 'kinds' : [
		\ 's:sections',
		\ 'i:images'
	\ ],
	\ 'sro' : '|',
	\ 'kind2scope' : {
		\ 's' : 'section',
	\ },
	\ 'sort': 0,
\ }

"vim-xkbswitch
let g:XkbSwitchEnabled = 1

"incsearch plugin
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
if(a:kwbdStage == 1)
	if(!buflisted(winbufnr(0)))
		bd!
		return
	endif
	let s:kwbdBufNum = bufnr("%")
	let s:kwbdWinNum = winnr()
	windo call s:Kwbd(2)
	execute s:kwbdWinNum . 'wincmd w'
	let s:buflistedLeft = 0
	let s:bufFinalJump = 0
	let l:nBufs = bufnr("$")
	let l:i = 1
	while(l:i <= l:nBufs)
		if(l:i != s:kwbdBufNum)
			if(buflisted(l:i))
				let s:buflistedLeft = s:buflistedLeft + 1
			else
				if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
					let s:bufFinalJump = l:i
				endif
			endif
		endif
		let l:i = l:i + 1
	endwhile
	if(!s:buflistedLeft)
		if(s:bufFinalJump)
			windo if(buflisted(winbufnr(0))) | execute "b!  " . s:bufFinalJump | endif
		else
			enew
			let l:newBuf = bufnr("%")
			windo if(buflisted(winbufnr(0))) | execute "b!  " . l:newBuf | endif
		endif
		execute s:kwbdWinNum .  'wincmd w'
	endif
	if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
		execute "bd!  " . s:kwbdBufNum
	endif
	if(!s:buflistedLeft)
		set buflisted
		set bufhidden=delete
		set buftype=
		setlocal noswapfile
	endif
else
	if(bufnr("%") == s:kwbdBufNum)
		let prevbufvar = bufnr("#")
		if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
			b #
		else
			bn
		endif
	endif
endif
endfunction

command!  Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>

" Create a mapping (e.g.  in your .vimrc) like this:
nmap <C-w> :Kwbd<CR>
