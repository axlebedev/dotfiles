" =============================================================================
" ====================begin VUNDLE ============================================

set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

" Keep Plugin commands between vundle#begin/end.
call vundle#begin()

" -----------------------------------------------------------------------------
Plugin 'VundleVim/Vundle.vim' "required

" -----------------------------------------------------------------------------
" Color theme 
Plugin 'crusoexia/vim-monokai'

" -----------------------------------------------------------------------------
" General purpose funcs for other plugins
Plugin 'l9'

" -----------------------------------------------------------------------------
" Search string or pattern in folder
" :Ack [options] {pattern} [{directories}]
" :grep = :Ack, :grepadd = :AckAdd, :lgrep = :LAck, :lgrepadd = :LAckAdd
Plugin 'mileszs/ack.vim'
" ag (https://github.com/ggreer/the_silver_searcher) integration
let g:ackprg = 'ag --vimgrep'

" -----------------------------------------------------------------------------
" Fuzzy file opener
Plugin 'kien/ctrlp.vim'
let g:ctrlp_map = '<C-t>'
let g:ctrlp_cmd = 'CtrlP'
" search hidden files too
let g:ctrlp_show_hidden = 1
" search in current dir and parents until folder containing '.git' or other
let g:ctrlp_working_path_mode = 'ra' 
" without next block it won't ignore wildcards' paths
if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif

" -----------------------------------------------------------------------------
" Highlight search matches immediately
Plugin 'haya14busa/incsearch.vim'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" TODO: maybe interesting plugin: incsearch-easymotion.vim

" -----------------------------------------------------------------------------
" NERD Tree
Plugin 'scrooloose/nerdtree'
" start NERDTree on vim startup
autocmd vimenter * NERDTree 
" even if we open dir but not file
autocmd StdinReadPre * let s:std_in=1 
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" close vim if only window is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" some configs of NERDTree
let g:NERDTreeDirArrows=1 " allow it to show arrows
let g:NERDTreeDirArrowExpandable='▸'
let g:NERDTreeDirArrowCollapsible='▾'
let g:NERDTreeShowHidden=1 " show hidden files
" TODO: if needed https://github.com/Xuyuanp/nerdtree-git-plugin

" -----------------------------------------------------------------------------
" plugin to make nerdtree be same on all tabs
Bundle 'jistr/vim-nerdtree-tabs'
let g:nerdtree_tabs_open_on_console_startup=1 " Open NERDTree on console vim startup
let g:nerdtree_tabs_focus_on_files=1 " When switching into a tab, make sure that focus is on the file window, not in the NERDTree window.
let g:nerdtree_tabs_autofind=1 " Automatically find and select currently opened file in NERDTree


" -----------------------------------------------------------------------------
" js code analysis tool
Plugin 'ternjs/tern_for_vim'

" -----------------------------------------------------------------------------
" ctags structure
Plugin 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

" -----------------------------------------------------------------------------
" comment lines, uncomment lines
Plugin 'scrooloose/nerdcommenter'
nnoremap <leader>c<Space> <C-_>
nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>

" -----------------------------------------------------------------------------
" vim-airline: cute statusbar at bottom
Plugin 'bling/vim-airline'
let g:airline_powerline_fonts = 1
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

" -----------------------------------------------------------------------------
" syntax checker
Plugin 'scrooloose/syntastic'
" some default configs
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" need to install checkers for different languages
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers

" -----------------------------------------------------------------------------
" Some common functions for next plugins
"Plugin 'LucHermitte/lh-vim-lib'
" autoclose parens on insert
"Plugin 'LucHermitte/lh-brackets'
"Plugin 'Townk/vim-autoclose'
Plugin 'jiangmiao/auto-pairsj'

" -----------------------------------------------------------------------------
" used only for filetype icons in ctrlP or nerdtree
Plugin 'ryanoasis/vim-devicons'

" -----------------------------------------------------------------------------
" Git from vim
" ':help fugitive' - lots of useful commands
Plugin 'tpope/vim-fugitive'

" -----------------------------------------------------------------------------
" Show 'N of M' while search
Plugin 'IndexedSearch'
let g:indexed_search_dont_move = 1

" -----------------------------------------------------------------------------
" multiple cursors on <C-n>
Plugin 'terryma/vim-multiple-cursors'

" -----------------------------------------------------------------------------
" Make '.' work on plugin commands (not all maybe)
Plugin 'tpope/vim-repeat'

" -----------------------------------------------------------------------------
" Surround. See docs on https://github.com/tpope/vim-surround
Plugin 'tpope/vim-surround'

" -----------------------------------------------------------------------------
" Make <C-a> and <C-x> work with dates (1999-12-30), time (00:00:03)
" roman numerals and ordinals (1st)
Plugin 'tpope/vim-speeddating'

" -----------------------------------------------------------------------------
" autoswitch language on leave insert mode
Plugin 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1

" -----------------------------------------------------------------------------
" Highlight matching html tag
Plugin 'MatchTag'

" -----------------------------------------------------------------------------
" autoclose html tags
Plugin 'alvan/vim-closetag'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.jsx"
" -----------------------------------------------------------------------------
" yank previous registers, more info at https://github.com/svermeulen/vim-easyclip
"Plugin 'svermeulen/vim-easyclip'

" -----------------------------------------------------------------------------
" navigate through previous plugin by <Tab>
"Plugin 'ervandew/supertab'
" make it go through list from top to bottom
"let g:SuperTabDefaultCompletionType = "<c-n>"
" -----------------------------------------------------------------------------
" autoshow complete pop
"Plugin 'othree/vim-autocomplpop'

" -----------------------------------------------------------------------------
" awesome complete features, deprecates supertab and autocomplpop
Plugin 'Valloric/YouCompleteMe'

" -----------------------------------------------------------------------------
" another autocomplete plugin
"Plugin 'Shougo/neocomplete.vim'

" -----------------------------------------------------------------------------
" jsx syntax highlight
Plugin 'mxw/vim-jsx'
" do it for 'js' files too, not only for 'jsx'
let g:jsx_ext_required = 0

" -----------------------------------------------------------------------------
" Indent guides
Plugin 'nathanaelkane/vim-indent-guides'
" indent guides colors
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#0f0f0f   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#1f1f1f ctermbg=4

" -----------------------------------------------------------------------------
" easy motions
Plugin 'easymotion/vim-easymotion'

" -----------------------------------------------------------------------------
"drwxr-xr-x  6 alex alex 4,0K Nov 12 22:49 vim-dispatch
" -----------------------------------------------------------------------------
"drwxr-xr-x  7 alex alex 4,0K Nov  1 21:33 vim-indent-guides

" -----------------------------------------------------------------------------
"drwxr-xr-x  8 alex alex 4,0K Oct 27 01:23 vim-javascript
" -----------------------------------------------------------------------------
"drwxr-xr-x  5 alex alex 4,0K Oct 27 01:24 vim-javascript-lib
" -----------------------------------------------------------------------------
"drwxr-xr-x  5 alex alex 4,0K Oct 27 01:12 vim-javascript-syntax

" -----------------------------------------------------------------------------
"drwxr-xr-x 10 alex alex 4,0K Oct 29 21:39 vim-markdown

" -----------------------------------------------------------------------------
"Plugin 'matchit' " PAPA TODO: проверить, нужен ли он вooбще?
" -----------------------------------------------------------------------------
call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" To install from command line: vim +PluginInstall +qall
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" ========================= VUNDLE end=========================================
" =============================================================================




" =============================================================================
" ====================begin GLOBAL CONFIGS ====================================

" where to search files to open
set path=.,,**

" ':' commands; search strings; expressions; input lines, typed for the |input()| function; debug mode commands history saved
set history=500

" lets insert-mode backspace to work everywhere
set backspace=indent,eol,start

" ignore files and folders on search
set wildignore+=*/node_modules/*,*/.git/* " *nix version
set wildignore+=*\\node_modules\\*,*\\.git\\* " windows version

" fix autocompletion of filenames in command-line mode
set wildmode=longest,list

if has('gui_running')
    set encoding=utf-8
    set fileencoding=utf-8
    set langmenu=en_US.UTF-8    " sets the language of the menu (gvim)
    "language en                " sets the language of the messages / ui (vim)
endif

" mouse for gnome-terminal
se mouse=a

" display line numbers
set number

" display currently inputed command
set showcmd

set tabstop=4      " width of TAB
set expandtab      " or 'noexpandtab': if set, inputs spaces instead of tabs
set softtabstop=4  " how much spaces will be removed on backspace
set shiftwidth=4   " count of spaces for '<'/'>' commands

set ai    " autoindents for new lines
set cin   " C-style indents

set timeoutlen=300 " PAPA TODO: comment this line

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Match HTML tags
runtime macros/matchit.vim

"Fix of Esc key while autocomplete popup is visible: return to Normal mode
let g:AutoClosePumvisible = {"ENTER": "\<C-y>", "Esc": "\<C-e>\<Esc>"}
" ========================= GLOBAL CONFIGS end=================================
" =============================================================================





" =============================================================================
" ====================begin APPEARANCE ========================================

" syntax color limit (0 for endless)
set synmaxcol=0

" enable syntax highlight
syntax on

" syntax color limit (0 for endless)
set synmaxcol=0

" 80 columns highlight
set cc=80

" enable syntax highlight
syntax on


if has('gui_running')

    if has("win32") || has("win16")
        set guifont=Droid\ Sans\ Mono\ for\ Powerline\ P:h10
    else
        set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types\ 11
    endif

    "set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=L  "remove left-hand scroll bar
    set guioptions+=e  "PAPA TODO: comment this line, it's about tabs

else

    " number of colors in terminal
    set t_Co=256

endif "has('gui_running')

" set colors of matching parens
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

" -----------------------------------------------------------------------------
" --------------------begin MONOKAI SETTINGS ----------------------------------

" colorscheme
colorscheme monokai

" If you are using a font which support italic, you can use below config to enable the italic form
let g:monokai_italic = 1

" The default window border is narrow dotted line, use below config to turn on the thick one
let g:monokai_thick_border = 1 " PAPA doesn't work (

" ------------------------- MONOKAI SETTINGS end-------------------------------
" -----------------------------------------------------------------------------


" -----------------------------------------------------------------------------
" --------------------begin NERDTREE HIGHLIGHT BY FILETYPES -------------------
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guifg='. a:guifg . ' guibg=' . a:guibg
 exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', 'NONE')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', 'NONE')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', 'NONE')
call NERDTreeHighlightFile('scss', 'cyan', 'none', 'cyan', 'NONE')
call NERDTreeHighlightFile('js', 'red', 'none', '#ffa500', 'NONE')
" ------------------------- NERDTREE HIGHLIGHT BY FILETYPES end----------------
" -----------------------------------------------------------------------------

" ========================= APPEARANCE end=====================================
" =============================================================================





" =============================================================================
" ====================begin KEY BINDINGS ======================================
nmap , <leader>

" fast save file
nmap <leader>w :w!<cr> 

inoremap jj <Esc>
inoremap оо <Esc>

" by default `Y` is equal `yy`, let it act like 'C' or 'D'
nnoremap Y y$

" <C-s> to split line
nnoremap <C-s> i<CR><Esc>

" comfortable navigation through windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" double-space to enter command-line
nnoremap <Space><Space> :

" clear search highlight
nnoremap <F12> :noh<CR>

" navigate through tabs
nnoremap <C-Tab> :bn<CR>
nnoremap <C-S-Tab> :bp<CR>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <C-M-j> mz:m+<cr>`z
nmap <C-M-k> mz:m-2<cr>`z
vmap <C-M-k> :m'<-2<cr>`>my`<mzgv`yo`z
vmap <C-M-j> :m'>+<cr>`<my`>mzgv`yo`z

" ========================= KEY BINDINGS end===================================
" =============================================================================





" =============================================================================
" ====================begin SEARCH/REPLACE ====================================

"defaults 'g' flag in substitute command
set gdefault

" highlights search results
set hlsearch

" TODO: comment following 2 lines
set ignorecase
set smartcase



" ========================= SEARCH/REPLACE end=================================
" =============================================================================





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
nmap <C-w> :Kwbd<CR>
