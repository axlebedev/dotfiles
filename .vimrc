" =ss1=ssvundle=        VUNDLE
" =ss2=ssglobals=       GLOBAL CONFIGS
" =ss3=ssappearance=    APPEARANCE
" =ss4=sskey=           KEY BINDINGS
" =ss5=ssfunctions=     FUNCTIONS



" =ss1=ssvundle================================================================
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
" NERD Tree
Plugin 'scrooloose/nerdtree'
" start NERDTree on vim startup
autocmd vimenter * NERDTree
" focus on editor window instead of NERDTree
autocmd VimEnter * wincmd p
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
" TODO: if need https://github.com/Xuyuanp/nerdtree-git-plugin

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
let g:syntastic_enable_signs=1
" some default configs
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']
" need to install checkers for different languages
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers

" -----------------------------------------------------------------------------
" Generate jsdoc easily
Plugin 'heavenshell/vim-jsdoc'
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_return_description = 1
let g:jsdoc_param_description_separator = ' - '

" -----------------------------------------------------------------------------
" One plugin to rule all the languages
Plugin 'othree/html5.vim'

" -----------------------------------------------------------------------------
" JavaScript bundle for vim, this bundle provides syntax and indent plugins
Plugin 'pangloss/vim-javascript'
let g:javascript_enable_domhtmlcss = 1

" -----------------------------------------------------------------------------
" ctags structure
Plugin 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

" -----------------------------------------------------------------------------
" Search string or pattern in folder
" :Ack [options] {pattern} [{directories}]
" :grep = :Ack, :grepadd = :AckAdd, :lgrep = :LAck, :lgrepadd = :LAckAdd
Plugin 'mileszs/ack.vim'

" -----------------------------------------------------------------------------
" autoclose parens
Plugin 'Raimondi/delimitMate'

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
" comment lines, uncomment lines
Plugin 'scrooloose/nerdcommenter'

" -----------------------------------------------------------------------------
" Highlight search matches immediately
Plugin 'haya14busa/incsearch.vim'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" TODO: maybe interesting plugin: incsearch-easymotion.vim
" TODO: Plugin 'IndexedSearch' conflicts with it: resolve

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
" yank previous registers
Plugin 'YankRing.vim'

" -----------------------------------------------------------------------------
" awesome complete features
"Plugin 'Valloric/YouCompleteMe'
"let g:ycm_add_preview_to_completeopt = 1
"let g:ycm_collect_identifiers_from_tags_files = 1
"Plugin 'othree/vim-autocomplpop'
"let g:acp_behavior-command = <C-x><C-o>
"Plugin 'ervandew/supertab'
Plugin 'Shougo/neocomplete.vim'
let g:acp_enableAtStartup = 0

" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 2
" Let it not to skip first completion
let g:neocomplete#enable_auto_select = 0 
" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <silent> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><Esc> pumvisible() ?  neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
" inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
"if !exists('g:neocomplete#sources#omni#input_patterns')
  "let g:neocomplete#sources#omni#input_patterns = {}
"endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" -----------------------------------------------------------------------------
call vundle#end()            " required
filetype plugin indent on    " required


" ========================= VUNDLE end=========================================
" =============================================================================










" =ss2=ssglobals===============================================================
" ====================begin GLOBAL CONFIGS ====================================
let s:vimdir = expand("~") . "/.vim"

" where to search files to open
set path=.,,**

" ':' commands; search strings; expressions; input lines, typed for the |input()| function; debug mode commands history saved
set history=500

" lets insert-mode backspace to work everywhere
set backspace=indent,eol,start

" ignore files and folders on search
" *nix version
set wildignore+=*/node_modules/*,*/.git/*,*.swp
" windows version
set wildignore+=*\\node_modules\\*,*\\.git\\*,*.swp

" fix autocompletion of filenames in command-line mode
set wildmode=longest,list

if has('gui_running')
    set encoding=utf-8
    set fileencoding=utf-8
    set langmenu=en_US.UTF-8    " sets the language of the menu (gvim)
endif "has('gui_running')

" mouse for gnome-terminal
set mouse=a

" display line numbers
set number

" display currently inputed command
set showcmd

set tabstop=4      " width of TAB
set expandtab      " or 'noexpandtab': if set, inputs spaces instead of tabs
set softtabstop=4  " how much spaces will be removed on backspace
set shiftwidth=4   " count of spaces for '<'/'>' commands

set autoindent    " autoindents for new lines
set smartindent

set timeoutlen=300 " how long will vim wait for key sequence completion

" Don't redraw while executing macros
set lazyredraw

" Turn backup off, since most stuff is in SVN, git etc anyway...
set nobackup
set nowb
set noswapfile

" Remember info about open buffers on close
set viminfo^=%

" Match HTML tags
runtime macros/matchit.vim

"defaults 'g' flag in substitute command
set gdefault

" TODO:? comment following 2 lines
set ignorecase
set smartcase

" store swapfiles in a central location
set directory=~/.vim/tmp/swap//,.,/var/tmp//,/tmp//
if !isdirectory(s:vimdir . '/tmp/swap')
    call mkdir(s:vimdir . '/tmp/swap', 'p')
endif

" enable persistent undo
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/tmp/undo
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p')
    endif
endif
  
" windows
set splitbelow
set splitright

" make out autocompletion more comfortable
set iskeyword+=$

" folding
set foldenable foldmethod=syntax
set foldlevelstart=99
" ========================= GLOBAL CONFIGS end=================================
" =============================================================================










" =ss3=ssappearance============================================================
" ====================begin APPEARANCE ========================================

" syntax color limit (0 for endless)
set synmaxcol=0

" enable syntax highlight
syntax on

" 80 columns highlight
set cc=80

" enable syntax highlight
syntax on

if has('gui_running')

    if has("win32") || has("win16")
        set guifont=Consolas:h10
    else
        set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types\ 11
    endif "has("win32") || has("win16")

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

" highlights search results
set hlsearch

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

" Color of find result background
highlight Search guibg='gray30' guifg='NONE'


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










" =ss4=sskey===================================================================
" ====================begin KEY BINDINGS ======================================
nmap <space> <leader>

" fast save file
nmap <leader>w :w!<cr>

" open file
nnoremap <Leader>o :CtrlP<CR>

inoremap jj <Esc>
inoremap оо <Esc>

" by default `Y` is equal `yy`, let it act like 'C' or 'D'
nnoremap Y y$

" split line
nnoremap <leader>s i<CR><Esc>

" comfortable navigation through windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" double-space to enter command-line
nnoremap <Space><Space> :

" clear search highlight
nnoremap <leader>n :noh<CR>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Move a line of text using Ctrl+Alt+[jk]
nmap <C-M-j> mz:m+<cr>`z
nmap <C-M-k> mz:m-2<cr>`z
vmap <C-M-k> :m'<-2<cr>`>my`<mzgv`yo`z
vmap <C-M-j> :m'>+<cr>`<my`>mzgv`yo`z

" Copy and paste through system slipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Some convenient file navigation
map <F2> :NERDTreeToggle<CR>
nmap <F5> :bprev<CR>
nmap <F6> :bnext<CR>

" apply macros with Q (disables the default Ex mode shortcut)
nnoremap Q @q
vnoremap Q :norm @q<CR>

" repeat command for each line in selection
xnoremap . :normal .<CR>

" reselect visual block after indent
xnoremap <silent> > >gv
xnoremap <silent> < <gv

" select pasted text
nmap vp `[v`]

" copy and paste ]
vnoremap <C-c> "+ygv<Esc>
vnoremap <C-x> "+d<Esc>
noremap <C-v>  "+gP
cnoremap <C-v> <C-r>+
exe 'inoremap <script> <C-v>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-v>' paste#paste_cmd['v']

" center find results
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
" ========================= KEY BINDINGS end===================================
" =============================================================================









" =ss5=ssfunctions=============================================================
" ====================begin FUNCTIONS =========================================

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


" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
