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
" General purpose funcs for other plugins
Plugin 'l9'

" -----------------------------------------------------------------------------
" Funcs maybe
" Plugin 'vim-scripts/lh-vim-lib'

" -----------------------------------------------------------------------------
" Custom submodes
Plugin 'kana/vim-submode'

" -----------------------------------------------------------------------------
" NERD Tree
Plugin 'scrooloose/nerdtree'
" start NERDTree on vim startup
augroup augroup_nerdtree
    autocmd!
    autocmd vimenter * NERDTree
    " focus on editor window instead of NERDTree
    autocmd VimEnter * wincmd p
    " even if we open dir but not file
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    " if we open dir - we dont show filetree in empty buffer
    autocmd VimEnter * if argc() == 1 && !filereadable(argv()[0]) | enew | endif
    " close vim if only window is NERDTree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
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

if has("win32") || has("win16")
	let g:airline_left_sep = ' '
	let g:airline_right_sep = ' '
	let g:airline_left_alt_sep = ' '
	let g:airline_right_alt_sep = ' '
	let g:airline_symbols.branch = ' '
	let g:airline_symbols.readonly = ' '
	let g:airline_symbols.linenr = ' '
else
	let g:airline_left_sep = ''
	let g:airline_right_sep = ''
	"let g:airline_left_sep = '▶'
	"let g:airline_right_sep = '◀'
	let g:airline_left_alt_sep = ''
	let g:airline_right_alt_sep = ''
	let g:airline_symbols.branch = ''
	let g:airline_symbols.readonly = ''
	let g:airline_symbols.linenr = ''
endif

" -----------------------------------------------------------------------------
" syntax checker
"Plugin 'scrooloose/syntastic'
"let g:syntastic_enable_signs=1
" some default configs
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 1

"let g:syntastic_javascript_checkers = ['eslint']
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
let g:javascript_plugin_jsdoc = 1

Plugin 'othree/javascript-libraries-syntax.vim'
let g:used_javascript_libs = 'underscore,react'

" -----------------------------------------------------------------------------
" Customize colors here
"Plugin 'othree/yajs.vim'
"Plugin 'othree/es.next.syntax.vim'
"Plugin 'bigfish/vim-js-context-coloring'
" -----------------------------------------------------------------------------
" jsx support
Plugin 'mxw/vim-jsx'
let g:jsx_ext_required = 0

" -----------------------------------------------------------------------------
"  TODO TODO TODO !!!
"Plugin 'ternjs/tern_for_vim'

" -----------------------------------------------------------------------------
" ctags structure
Plugin 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>
let g:tagbar_width = 80
let g:tagbar_autofocus = 1

" -----------------------------------------------------------------------------
" Search string or pattern in folder
" :Ack [options] {pattern} [{directories}]
" :grep = :Ack, :grepadd = :AckAdd, :lgrep = :LAck, :lgrepadd = :LAckAdd
Plugin 'mileszs/ack.vim'

" -----------------------------------------------------------------------------
" autoclose parens
Plugin 'Raimondi/delimitMate'
let delimitMate_excluded_ft = 'html'
let delimitMate_nesting_quotes = ['"','`']
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1

" -----------------------------------------------------------------------------
" Fuzzy file opener
Plugin 'ctrlpvim/ctrlp.vim'
"let g:ctrlp_map = '<C-t>'
let g:ctrlp_map = '<leader>t'
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
" Sublime's <C-r> analog
" TODO: wait until es6 supported
" Plugin 'tacahiroy/ctrlp-funky'
" nnoremap <Leader>r :CtrlPFunky<Cr>

" -----------------------------------------------------------------------------
" comment lines, uncomment lines
Plugin 'tpope/vim-commentary'

" -----------------------------------------------------------------------------
" Show 'n of m' result
Plugin 'henrik/vim-indexed-search'

" -----------------------------------------------------------------------------
" multiple cursors on <C-n>
"Plugin 'terryma/vim-multiple-cursors'
"let g:multi_cursor_use_default_mapping=0
"let g:multi_cursor_next_key='<M-n>'
"let g:multi_cursor_prev_key='<M-p>'
"let g:multi_cursor_skip_key='<M-x>'
"let g:multi_cursor_quit_key='<Esc>'
"set selection=inclusive

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
" TODO: doesn't close if we use neocomplete 

" -----------------------------------------------------------------------------
" yank previous registers
Plugin 'YankRing.vim'
nnoremap <silent> <F11> :YRShow<CR>

" -----------------------------------------------------------------------------
" awesome complete features
"Plugin 'Valloric/YouCompleteMe'
"let g:ycm_add_preview_to_completeopt = 1
"let g:ycm_collect_identifiers_from_tags_files = 1
"Plugin 'othree/vim-autocomplpop'
"let g:acp_behavior-command = <C-x><C-o>
"Plugin 'ervandew/supertab'

" First, close the foldmethod bug
Plugin 'Konfekt/FastFold'

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

augroup augroup_neocomplete
    autocmd!
    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

" Enable heavy omni completion.
"if !exists('g:neocomplete#sources#omni#input_patterns')
  "let g:neocomplete#sources#omni#input_patterns = {}
"endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'


" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" -----------------------------------------------------------------------------
" color highlight in text
Plugin 'ap/vim-css-color'

" -----------------------------------------------------------------------------
" Indent line for leading spaces
Plugin 'Yggdroot/indentLine'
" Warning! needed to patch font as described at https://github.com/Yggdroot/indentLine
if has("win32") || has("win16")
    let g:indentLine_char = '⁞'
else
    let g:indentLine_char = ''
endif "has("win32") || has("win16")

" -----------------------------------------------------------------------------
" Smooth scroll
"Plugin 'yonchu/accelerated-smooth-scroll'
"Plugin 'file:///home/alex/.vim/bundle/smoooth.vim'

" -----------------------------------------------------------------------------
" Color theme
Plugin 'crusoexia/vim-monokai'

" -----------------------------------------------------------------------------
" Delete all buffers but current
Plugin 'schickling/vim-bufonly'

" -----------------------------------------------------------------------------
" Some more text objects
Plugin 'wellle/targets.vim'

" -----------------------------------------------------------------------------
" Split/join js-objects (and many more)
Plugin 'AndrewRadev/splitjoin.vim'

" -----------------------------------------------------------------------------
" EasyMotion like in chrome
Plugin 'easymotion/vim-easymotion'
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1 " Turn on case insensitive feature
nmap t <Plug>(easymotion-overwin-f)
nmap tt <Plug>(easymotion-overwin-f2)

" -----------------------------------------------------------------------------
" :Qdo
Plugin 'henrik/vim-qargs'

" -----------------------------------------------------------------------------
" Pretty work with git
Plugin 'tpope/vim-fugitive'
Plugin 'junegunn/gv.vim'

" -----------------------------------------------------------------------------
" expand selection
Plugin 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" -----------------------------------------------------------------------------
" My ^^
Plugin 'alexey-broadcast/vim-js-fastlog'

" -----------------------------------------------------------------------------
call vundle#end()            " required
filetype plugin indent on    " required


" sspe===================== VUNDLE end=========================================
" =============================================================================










" =ss2=ssglobals===============================================================
" ====================begin GLOBAL CONFIGS ====================================
let s:vimdir = expand("~") . "/.vim"

" english vim interface language
set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" dont save files on change buffer
set hidden

" autoreload files when they're changed on disk
set autoread

" keep lines above/below cursor
set scrolloff=5

" where to search files to open
set path=.,,**

" lets insert-mode backspace to work everywhere
set backspace=indent,eol,start

" ignore files and folders on search
set wildignore+=*.sqp,*.log
" *nix version
set wildignore+=*/node_modules/*,*/bower_components/*,*/.git/*,*/build/*,*/dist/*
" windows version
set wildignore+=*\\node_modules\\*,*\\bower_components\\*,*\\.git\\*,*\\build\\*,*\\dist\\*

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

" indent settings
set tabstop=4      " width of TAB
set expandtab      " or 'noexpandtab': if set, inputs spaces instead of tabs
set softtabstop=4  " how much spaces will be removed on backspace
set shiftwidth=4   " count of spaces for '<'/'>' commands
set shiftround     " smart indent for '<'/'>' commands
set smarttab       " insert tabs on the start of a line according to shiftwidth, not tabstop
au FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

set autoindent    " autoindents for new lines
set smartindent

set timeoutlen=300 " how long will vim wait for key sequence completion

" Don't redraw while executing macros
set lazyredraw

" ':' commands; search strings; expressions; input lines, typed for the |input()| function; debug mode commands history saved
set history=500

" Turn backup off
set nobackup
set nowb
set noswapfile

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

" Remember info about open buffers on close
set viminfo^=%

" Match HTML tags
runtime macros/matchit.vim

" Avoid all the hit-enter prompts
set shortmess=aAItW

"defaults 'g' flag in substitute command
"set gdefault

" TODO:? comment following 2 lines
set ignorecase
set smartcase
  
" windows
set splitbelow
set splitright

" make out autocompletion more comfortable
set iskeyword+=$

" folding
set foldenable 
set foldmethod=syntax
set foldcolumn=0
set foldlevelstart=99
" HTML/XML Folding
"au BufNewFile,BufRead *.xml,*.htm,*.html so ~/.vim/bundle/XMLFolding.vim
"autocmd BufNewFile,BufReadPost *.less set filetype=stylesheet

"
set incsearch

" Keep the cursor in the same place when switching buffers
set nostartofline

" don't add extra space after ., !, etc. when joining
set nojoinspaces

" Disable error bells
set noerrorbells

" Don't show the intro message when starting Vim
" Also suppress several 'Press Enter to continue messages' especially
" with FZF
set shortmess=aoOtI


augroup augroup_settings_global
    autocmd!
    " Override some syntaxes so things look better
    autocmd BufNewFile,BufRead *eslintrc,*babelrc,*conkyrc setlocal syntax=json

    " Allow stylesheets to autocomplete hyphenated words
    autocmd FileType css,scss,sass setlocal iskeyword+=-

    " when quickfix window is opened - it will be at bottom, but keep NERDTree at left
    autocmd FileType qf wincmd J | wincmd k | wincmd H | vertical resize 31 | wincmd l | wincmd j

    " set filetype for 'md' files
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
augroup END

" ignore whitespace in diff mode
if &diff
    set diffopt+=iwhite
endif

augroup git_files "{{{
    au!
    " Don't remember the last cursor position when editing commit
    " messages, always start on line 1
    autocmd filetype gitcommit call setpos('.', [0, 1, 1, 0])
augroup end "}}}

" ========================= GLOBAL CONFIGS end=================================
" =============================================================================










" =ss3=ssappearance============================================================
" ====================begin APPEARANCE ========================================

" syntax color limit (0 for endless)
set synmaxcol=500

" enable syntax highlight
syntax on

" 80 columns highlight
set cc=100

if has('gui_running')

    if has("win32") || has("win16")
        set guifont=Consolas:h10
    else
        set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types\ 11
    endif "has("win32") || has("win16")

    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=L  "remove left-hand scroll bar

    " Maximize gvim window.
    set lines=999 columns=999
else

    " number of colors in terminal
    set t_Co=256

endif "has('gui_running')

" highlights search results
set hlsearch

" -----------------------------------------------------------------------------
" --------------------begin MONOKAI SETTINGS ----------------------------------

" If you are using a font which support italic, you can use below config to enable the italic form
let g:monokai_italic = 1

" The default window border is narrow dotted line, use below config to turn on the thick one
let g:monokai_thick_border = 1 " PAPA doesn't work (

" colorscheme
colorscheme monokai

" ------------------------- MONOKAI SETTINGS end-------------------------------
" -----------------------------------------------------------------------------

" Color of find result background
highlight Search guibg='#4A3F2D' guifg='NONE'

" set colors of matching parens
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta gui=bold guibg=#8C5669 guifg=NONE

" colors of fold column
hi FoldColumn guibg=#131411 guifg=#34352E

" colors of error column
hi SignColumn guibg=#131411

" colors of line number column
hi LineNr guibg=#131411 guifg=#34352E

" highlight current line number
set cursorline
hi clear CursorLine
hi CursorLineNr guifg=#68705e guibg=#131411

" colors and appearance of window split column
set fillchars+=vert:│
hi VertSplit guibg=#131411 guifg=#131411

" -----------------------------------------------------------------------------
" --------------------begin NERDTREE HIGHLIGHT BY FILETYPES -------------------
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'augroup augroup_nerdtree_highlight'
    exec 'autocmd!'
    exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guifg='. a:guifg . ' guibg=' . a:guibg
    exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
    exec 'augroup END'
endfunction
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', 'NONE')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', 'NONE')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', 'NONE')
call NERDTreeHighlightFile('scss', 'cyan', 'none', 'cyan', 'NONE')
call NERDTreeHighlightFile('js', 'red', 'none', '#ffa500', 'NONE')

" Also, turn off 'Press ? for help' label
let NERDTreeMinimalUI=1
" ------------------------- NERDTREE HIGHLIGHT BY FILETYPES end----------------
" -----------------------------------------------------------------------------

" show invisible chars
if has("win32") || has("win16")
    set listchars=tab:⁞\ ,trail:·,extends:»,precedes:«,conceal:_,nbsp:•
else
    set listchars=tab:↳\ ,trail:·,extends:»,precedes:«,conceal:_,nbsp:•
endif
set list

" show wrapped line marker
set showbreak=»

" ========================= APPEARANCE end=====================================
" =============================================================================








" =ss4=sskey===================================================================
" ====================begin KEY BINDINGS ======================================

" TODO: fix it
let mapleader = "\<space>"
nmap <space> <leader>
vmap <space> <leader>
xmap <space> <leader>

" fast open/reload vimrc
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" Avoid accidental hits of <F1> while aiming for <Esc>
noremap! <F1> <Esc>

" Swap these two
nnoremap 0 ^
nnoremap ^ 0
nnoremap 00 0

" fast save file
nmap <leader>w :w!<cr>

" fast close
nmap <leader>q <Plug>Kwbd

" new empty buffer
nmap <leader>x :enew<cr>

" open file
nnoremap <Leader>o :CtrlP<CR>

" return to normal mode by double-j
inoremap jj <Esc>
" same but in cyrillic layout
inoremap оо <Esc>

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

" clear search highlight
nnoremap <leader>n :noh<CR>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Move a line of text using Ctrl+Alt+[jk]
nmap <C-M-j> mz:m+<cr>`z
nmap <C-M-k> mz:m-2<cr>`z
vmap <C-M-k> :m'<-2<cr>`>my`<mzgv`yo`z
vmap <C-M-j> :m'>+<cr>`<my`>mzgv`yo`z

" Some convenient file navigation
map <F2> :NERDTreeToggle<CR>
nmap <leader>tt :NERDTreeFind<CR>

" apply macros with Q (disables the default Ex mode shortcut)
nnoremap Q @q
vnoremap Q :norm @q<CR>

" repeat command for each line in selection
xnoremap . :normal .<CR>

" reselect visual block after indent
xnoremap <silent> > >gv
xnoremap <silent> < <gv

" Copy and paste through system slipboard
vmap Y "+y
nmap <Leader>p "+p
nmap <Leader>P "+P

" Movement in wrapped lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" center find results
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" toggle fold on tripleclick
noremap <3-LeftMouse> za

" insert blank line
nnoremap <leader><CR> o<Esc>
nnoremap <leader>o o<Esc>

" save file under root
cmap w!! w !sudo tee % >/dev/null

" replace selection
vnoremap <C-h> "hy:%s/<C-r>h//gc<left><left><left><C-r>h

" visual select all
nnoremap <M-a> ggVG

" pretty find
vnoremap // y/<C-R>"<CR>

" add a symbol to current line
nnoremap <leader>; A;<Esc>
nnoremap <leader>, A,<Esc>

" reload all buffers
nnoremap <M-r> :bufdo<space>e!<CR>

" λ
nnoremap <leader>il iλ<Esc>
nnoremap <leader>al aλ<Esc>

" type ':S<cr>' to split current buffer to right, and leave it with previous buffer
command! S vs | wincmd h | bprev | wincmd l

" Toggling True/False
nnoremap <silent> <C-t> mmviw:s/true\\|false/\={'true':'false','false':'true'}[submatch(0)]/<CR>`m:nohlsearch<CR>

" some custom digraphs
digraphs TT 8869

" avoid mistypes :)
abbr funciton function

" Resize submode
let g:submode_always_show_submode = 1
let g:submode_timeout = 0
let resizeSubmode = 'Resize'
call submode#enter_with(resizeSubmode, 'n', '', '<M-r>')
call submode#map(resizeSubmode, 'n', '', 'h', ':vertical resize -1<cr>')
call submode#map(resizeSubmode, 'n', '', 'l', ':vertical resize +1<cr>')
call submode#map(resizeSubmode, 'n', '', 'k', ':resize -1<cr>')
call submode#map(resizeSubmode, 'n', '', 'j', ':resize +1<cr>')

" JsFastLog mappings
nnoremap <silent> <leader>l :<C-u>call JsFastLog(0)<CR>
nnoremap <silent> <leader>ll :<C-u>call JsFastLog_stringify()<CR>
nnoremap <silent> <leader>ld :<C-u>call JsFastLog_function()<CR>
nnoremap <silent> <leader>ls :<C-u>call JsFastLog_string()<CR>
nnoremap <silent> <leader>lk :<C-u>call JsFastLog_dir()<CR>
xnoremap <silent> <leader>l :<C-u>call JsFastLog(0)<CR>
xnoremap <silent> <leader>ll :<C-u>call JsFastLog_stringify()<CR>
xnoremap <silent> <leader>ld :<C-u>call JsFastLog_function()<CR>
xnoremap <silent> <leader>ls :<C-u>call JsFastLog_string()<CR>
xnoremap <silent> <leader>lk :<C-u>call JsFastLog_dir()<CR>

" ========================= KEY BINDINGS end===================================
" =============================================================================









" =ss5=ssfunctions=============================================================
" ====================begin FUNCTIONS =========================================

" -----------------------------------------------------------------------------
" Markdown tagbar support
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '/home/alex/dotfiles/markdown2ctags.py',
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

" -----------------------------------------------------------------------------
" toggle foldColumn
nnoremap <leader>f :call FoldColumnToggle()<cr>

function! FoldColumnToggle()
    if &foldcolumn > 0
        setlocal foldcolumn=0
    else 
        setlocal foldcolumn=12
    endif
endfunction

" -----------------------------------------------------------------------------
" toggle centering cursor
nnoremap <leader>c :call ReadModeToggle()<cr>

function! ReadModeToggle()
    if &scrolloff > 10
        setlocal &l:scrolloff = g:scrolloff_value
        setlocal virtualedit=block
    else 
        let g:scrolloff_value = &scrolloff
        setlocal scrolloff=999
        setlocal virtualedit=all

    endif
endfunction

" -----------------------------------------------------------------------------
" next functions makes:
function! YRRunAfterMaps()
    " nnoremap Y y$ but in YankRing-compatible way
    nnoremap Y :<C-U>YRYankCount 'y$'<CR>

    vnoremap <silent> y y`]
    vmap p :<C-u>call VisualPaste()<cr>
    nnoremap <silent> p p`]
endfunction

function! VisualPaste()
    let currentMode = visualmode()
    if (currentMode ==# 'v')
        :execute "normal! gv\"_c\<esc>p"
    elseif (currentMode ==# 'V')
        :execute "normal! gv\"_dP`]"
    elseif
        :execute "normal! gvp"
    endif
endfunction

" -----------------------------------------------------------------------------
" Toggle quickfix/location window
" From Steve Losh, http://learnvimscriptthehardway.stevelosh.com/chapters/38.html
nnoremap <leader>b :call <SID>QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! s:QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

" -----------------------------------------------------------------------------
"  http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window
"here is a more exotic version of my original Kwbd script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function! s:Kwbd(kwbdStage)
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
                windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
        else
            enew
            let l:newBuf = bufnr("%")
            windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
    endif
    execute s:kwbdWinNum . 'wincmd w'
endif
if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
    execute "bd! " . s:kwbdBufNum
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

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>
" Create a mapping (e.g. in your .vimrc) like this:
"nmap <C-W>! <Plug>Kwbd



" -----------------------------------------------------------------------------
" Skip quickfix on traversing buffers
nnoremap <leader>j :<C-u>call OpenNextBuf(1)<CR>
nnoremap <leader>k :<C-u>call OpenNextBuf(0)<CR>
function! OpenNextBuf(prev)
    let l:command = "bnext"
    if(a:prev == 1)
        let l:command = "bprev"
    endif
    :execute l:command
    if &buftype ==# 'quickfix'
        :execute l:command
    endif
endfunction

" -----------------------------------------------------------------------------
" make gd to work with import
nnoremap <F5> :<C-u>call GoToImportDefinition()<CR>
let s:isGoingToImportDefinition = 0
function! GoToImportDefinition()
    let s:isGoingToImportDefinition = 1
    :execute "normal! gd"
    let l:isImport = matchstr(getline("."), "import")
    if empty(l:isImport)
        " do nothing
    else
        :execute "normal! f'gf"
    endif
endfunction

autocmd BufEnter *
\ if s:isGoingToImportDefinition == 1 |
\   :execute "normal! nzz" |
\   let s:isGoingToImportDefinition = 0 |
\ endif

" -----------------------------------------------------------------------------
" Delete trailing white space on save
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

" ----------------------------------------------------------------------------
" Todo
function! s:todo() abort
    let entries = []
    for cmd in ['git grep -n -e TODO -e FIXME -e XXX 2> /dev/null',
                \ 'grep -rn -e TODO -e FIXME -e XXX * 2> /dev/null']
        let lines = split(system(cmd), '\n')
        if v:shell_error != 0 | continue | endif
        for line in lines
            let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
            call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
        endfor
        break
    endfor

    if !empty(entries)
        call setqflist(entries)
        copen
    endif
endfunction
command! Todo call s:todo()

" ----------------------------------------------------------------------------
" <Leader>?/! | Google it / Feeling lucky
function! s:goog(pat, lucky)
    echom 'goog'
    echom pat
    let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
    echom q
    let q = substitute(q, '[[:punct:] ]',
                \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
    echom q
    call system(printf('xdg-open "https://www.google.com/search?%sq=%s"',
                \ a:lucky ? 'btnI&' : '', q))
endfunction

nnoremap <F3> :call <SID>goog(expand("<cWORD>"), 0)<cr>
" nnoremap <leader>! :call <SID>goog(expand("<cWORD>"), 1)<cr>
xnoremap <F3> "gy:call <SID>goog(@g, 0)<cr>gv
" xnoremap <leader>! "gy:call <SID>goog(@g, 1)<cr>gv

" ----------------------------------------------------------------------------
" find word under cursor
function! s:globalFind()
    let word = ""
    if (visualmode() == 'v')
        let word = l9#getSelectedText()
    else
        let word = expand("<cword>")
    endif

    let searchingWord = input('Searching text: ', word)

    if (empty(searchingWord))
        return
    endif

    let delimiter = '/'
    if has("win32") || has("win16")
        let delimiter = '\'
    endif

    :execute ':vim /'.searchingWord.'/j src'.delimiter.'** | cw'
endfunction

nnoremap <C-f> :call <SID>globalFind()<cr>
xnoremap <C-f> :call <SID>globalFind()<cr>


" " find/replace in current project
if has("win32") || has("win16")
"     nnoremap <C-f> :vim<space>//j<space>src\**\|cw<left><left><left><left><left><left><left><left><left><left><left><left><C-r><C-w>
"     vnoremap <C-f> "fy:vim<space>//j<space>src\**\|cw<left><left><left><left><left><left><left><left><left><left><left><left><C-r>f
"     " Plugin 'henrik/vim-qargs' neede for next line
    nnoremap <M-h> :Qdo %s/<C-r>f//gce\|update<left><left><left><left><left><left><left><left><left><left><left><C-r>f
else
"     nnoremap <C-f> :vim<space>//j<space>src/**\|cw<left><left><left><left><left><left><left><left><left><left><left><left><C-r><C-w>
"     vnoremap <C-f> "fy:vim<space>//j<space>src/**\|cw<left><left><left><left><left><left><left><left><left><left><left><left><C-r>f
"     " Plugin 'henrik/vim-qargs' neede for next line
    nnoremap <M-h> :Qdo %s/\<<C-r>f\>//gce\|update<left><left><left><left><left><left><left><left><left><left><left><C-r>f
endif

"
"
"
" -----------------------------------------------------------------------------
augroup augroup_functions
    autocmd!
    " -------------------------------------------------------------------------
    " Return to last edit position when opening files (You want this!)
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif

    " -------------------------------------------------------------------------
    " Close empty buffer on leave
    autocmd BufLeave *
        \ if line('$') == 1 && getline(1) == '' && expand('%:t') |
        \     exe 'Kwbd' |
        \ endif

    autocmd BufWrite *.js :call DeleteTrailingWS()
augroup END
