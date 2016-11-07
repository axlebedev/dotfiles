" =ss1=ssplugin=        VUNDLE
" =ss2=ssglobals=       GLOBAL CONFIGS
" =ss3=ssappearance=    APPEARANCE
" =ss4=sskeyboard=      KEY BINDINGS
" =ss5=ssfunctions=     FUNCTIONS
" TODO: 'help' to be always in readmode
" TODO: fox <C-t> if there are several values in line



" Plugin settings ============================= {{{
" =ss1=ssplugin=

set nocompatible
filetype off

" vim-plug installation:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.vim/bundle')
" -----------------------------------------------------------------------------
" General purpose funcs for other plugins
Plug 'l9'
" Plug 'lh-vim-lib'

" -----------------------------------------------------------------------------
" Custom submodes
Plug 'kana/vim-submode'

" -----------------------------------------------------------------------------
" Command-line output to temp buffer
Plug 'AndrewRadev/bufferize.vim'

" -----------------------------------------------------------------------------
" Markdown live preview
" npm i -g livedown
Plug 'shime/vim-livedown'

" -----------------------------------------------------------------------------
" NERD Tree
Plug 'scrooloose/nerdtree'
" TODO: read help
" start NERDTree on vim startup
augroup augroup_nerdtree
    autocmd!
    autocmd VimEnter * NERDTree
    " focus on editor window instead of NERDTree
    autocmd VimEnter * wincmd p
    " focus on editor window instead of NERDTree even if we open dir but not file
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    " if we open dir - we dont show filetree in empty buffer
    autocmd VimEnter * if argc() == 1 && !filereadable(argv()[0]) | enew | endif
    " close vim if only window is NERDTree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
" some configs of NERDTree
let NERDTreeDirArrows=1 " allow it to show arrows
let NERDTreeDirArrowExpandable='▸'
let NERDTreeDirArrowCollapsible='▾'
let NERDTreeShowHidden=1 " show hidden files
" TODO: if need https://github.com/Xuyuanp/nerdtree-git-plugin

" -----------------------------------------------------------------------------
" vim-airline: cute statusbar at bottom
Plug 'bling/vim-airline'
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
    let g:airline_left_alt_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
endif

" -----------------------------------------------------------------------------
" Generate jsdoc easily
Plug 'heavenshell/vim-jsdoc'
let g:jsdoc_enable_es6 = 1
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_return_type = 1
let g:jsdoc_return_description = 1
let g:jsdoc_param_description_separator = ' - '

" -----------------------------------------------------------------------------
" One plugin to rule all the languages
Plug 'othree/html5.vim'

" -----------------------------------------------------------------------------
" JavaScript bundle for vim, this bundle provides syntax and indent plugins
Plug 'pangloss/vim-javascript'
let g:javascript_enable_domhtmlcss = 1
let g:javascript_plugin_jsdoc = 1

Plug 'othree/javascript-libraries-syntax.vim'
let g:used_javascript_libs = 'underscore,react'
Plug 'othree/es.next.syntax.vim'
" -----------------------------------------------------------------------------
" Customize colors here
" TODO: ???
"Plug 'othree/yajs.vim'
"Plug 'othree/es.next.syntax.vim'
"Plug 'bigfish/vim-js-context-coloring'
" -----------------------------------------------------------------------------
" jsx support
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0

" -----------------------------------------------------------------------------
"  TODO TODO TODO !!!
"Plug 'ternjs/tern_for_vim'

" -----------------------------------------------------------------------------
" ctags structure
Plug 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>
let g:tagbar_width = 80
let g:tagbar_autofocus = 1
" markdown support
let g:tagbar_type_markdown = {
    \ 'ctagstype':  'markdown',
    \ 'ctagsbin':   '/home/alex/dotfiles/markdown2ctags.py',
    \ 'ctagsargs':  '-f - --sort=yes',
    \ 'kinds':      ['s:sections', 'i:images'],
    \ 'sro':        '|',
    \ 'kind2scope': { 's': 'section' },
    \ 'sort':       0,
\ }

" -----------------------------------------------------------------------------
" Search string or pattern in folder
Plug 'mileszs/ack.vim'
if executable('ag') " sudo apt-get install silversearcher-ag
  let g:ackprg = 'ag --ignore-dir ".git bin logs node_modules static webpack"'
endif

" -----------------------------------------------------------------------------
" autoclose parens
Plug 'Raimondi/delimitMate'
let delimitMate_excluded_ft = 'html'
let delimitMate_nesting_quotes = ['"','`']
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1

" -----------------------------------------------------------------------------
" Fuzzy file opener
Plug 'ctrlpvim/ctrlp.vim'
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
" clear cache on vim exit
let g:ctrlp_clear_cache_on_exit = 1
" Include current file to find entries
let g:ctrlp_match_current_file = 1

" -----------------------------------------------------------------------------
" Sublime's <C-r> analog
" TODO: wait until es6 supported
" Plug 'tacahiroy/ctrlp-funky'
" nnoremap <leader>r :CtrlPFunky<Cr>

" -----------------------------------------------------------------------------
" comment lines, uncomment lines
Plug 'tomtom/tcomment_vim'
let g:tcommentTextObjectInlineComment = 'ix'

" -----------------------------------------------------------------------------
" Show 'n of m' result
Plug 'henrik/vim-indexed-search'

" -----------------------------------------------------------------------------
" Make '.' work on plugin commands (not all maybe)
Plug 'tpope/vim-repeat'

" -----------------------------------------------------------------------------
" Surround. See docs on https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

" -----------------------------------------------------------------------------
" autoswitch language on leave insert mode
Plug 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1

" -----------------------------------------------------------------------------
" Highlight matching html tag
Plug 'MatchTag'

" -----------------------------------------------------------------------------
" autoclose html tags
Plug 'alvan/vim-closetag'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.jsx"
" TODO: doesn't close if we use neocomplete 

" -----------------------------------------------------------------------------
" yank previous registers
Plug 'YankRing.vim'
nnoremap <silent> <F11> :YRShow<CR>

" -----------------------------------------------------------------------------
" First, close the foldmethod bug
Plug 'Konfekt/FastFold'

Plug 'Shougo/neocomplete.vim'
" TODO: read help
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
" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ?
  \ "\<C-n>" : SmartInsertTab()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

augroup augroup_neocomplete
    autocmd!
    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

" -----------------------------------------------------------------------------
" color highlight in text
Plug 'ap/vim-css-color'

" -----------------------------------------------------------------------------
" Indent line for leading spaces
Plug 'Yggdroot/indentLine'
" Warning! needed to patch font as described at https://github.com/Yggdroot/indentLine
" if has("win32") || has("win16")
let g:indentLine_char = '┆'

" else
    " let g:indentLine_char = ''
" endif "has("win32") || has("win16")

" -----------------------------------------------------------------------------
" Color theme
Plug 'crusoexia/vim-monokai'

" -----------------------------------------------------------------------------
" Delete all buffers but current
Plug 'schickling/vim-bufonly'

" -----------------------------------------------------------------------------
" Some more text objects
Plug 'wellle/targets.vim'
let g:targets_pairs = '()b {}c [] <>' " replace {}B to {}c

" -----------------------------------------------------------------------------
" Split/join js-objects (and many more)
" TODO: read doc, maybe remove
Plug 'AndrewRadev/splitjoin.vim'

" -----------------------------------------------------------------------------
" EasyMotion like in chrome
Plug 'easymotion/vim-easymotion'
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1 " Turn on case insensitive feature
nmap t <Plug>(easymotion-overwin-f)
nmap tt <Plug>(easymotion-overwin-f2)

" -----------------------------------------------------------------------------
" :Qdo
Plug 'henrik/vim-qargs'

" -----------------------------------------------------------------------------
" Pretty work with git
" TODO: READ the fucking docs, WATCH screencasts
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" -----------------------------------------------------------------------------
" expand selection
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

Plug 'Valloric/ListToggle'
let g:lt_location_list_toggle_map = '<leader>0'
let g:lt_quickfix_list_toggle_map = '<leader>b'

" -----------------------------------------------------------------------------
" My ^^
" Plug 'alexey-broadcast/vim-js-fastlog'
Plug 'file:///home/alex/hdd/Proj/vim-js-fastlog'
" Plug 'alexey-broadcast/vim-smart-insert-tab'
Plug 'file:///home/alex/hdd/Proj/vim-smart-insert-tab'

Plug 'isomoar/vim-css-to-inline'

" -----------------------------------------------------------------------------
call plug#end()
filetype plugin indent on
" }}}





" Plugin settings ============================= {{{
" =ss2=ssglobals=

let s:vimdir = expand("~") . "/.vim"

" remove all commands on re-read .vimrc file
augroup au_vimrc
    autocmd!
augroup END

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
set sidescrolloff=15
set sidescroll=1

" where to search files to open
set path=.,,**

" lets insert-mode backspace to work everywhere
set backspace=indent,eol,start

" ignore files and folders on search
set wildignore+=*.sqp,*.log
" *nix version
set wildignore+=*/node_modules/*,*/bower_components/*,*/build/*,*/dist/*
" windows version
set wildignore+=*\\node_modules\\*,*\\bower_components\\*,*\\build\\*,*\\dist\\*

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
set autoindent     " autoindents for new lines
set smartindent
au FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

set timeoutlen=300 " how long will vim wait for key sequence completion

" Don't redraw while executing macros
set lazyredraw

" ':' commands; search strings; expressions; input lines, typed for the |input()| function; debug mode commands history saved
set history=500

" Turn backup off and store swapfiles in a central location
set nobackup
set nowb
set noswapfile
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

" Avoid all the hit-enter prompts
set shortmess=aAItW

" smartcase for search
set ignorecase
set smartcase

" new window open at bottom-right by default
set splitbelow
set splitright

" folding
set foldenable 
set foldmethod=syntax
set foldcolumn=0
set foldlevelstart=99

" Keep the cursor in the same place when switching buffers
set nostartofline

" don't add extra space after ., !, etc. when joining
set nojoinspaces

" Disable error bells
set noerrorbells

" Don't show the intro message when starting Vim
" Also suppress several 'Press Enter to continue messages' especially with FZF
set shortmess=aoOtI

" Override some syntaxes so things look better
autocmd au_vimrc BufNewFile,BufRead *eslintrc,*babelrc,*conkyrc setlocal syntax=json

" Allow stylesheets to autocomplete hyphenated words
autocmd au_vimrc FileType css,scss,sass setlocal iskeyword+=-

" set filetype for 'md' files
autocmd au_vimrc BufNewFile,BufReadPost *.md set filetype=markdown

" set foldmethod for vimscripts
autocmd au_vimrc FileType vim setlocal foldmethod=marker colorcolumn=80

" ignore whitespace in diff mode
if &diff
    set diffopt+=iwhite
endif

" Don't remember the last cursor position when editing commit
" messages, always start on line 1
autocmd au_vimrc filetype gitcommit call setpos('.', [0, 1, 1, 0])

" Match HTML tags
runtime macros/matchit.vim

" Vim now also uses the selection system clipboard for default yank/paste.
if has('unnamedplus')
  " See :h 'clipboard' for details.
  set clipboard=unnamedplus,unnamed
else
  set clipboard+=unnamed
endif
" }}}





" Appearance settings ============================= {{{
" =ss3=ssappearance=

" syntax color limit (0 for endless)
set synmaxcol=500

" enable syntax highlight
syntax on

" 100 columns highlight
set colorcolumn=100

if has('gui_running')
    if has("win32") || has("win16")
        set guifont=Consolas:h10
    else
        set guifont=DroidSansMonoforPowerline\ Nerd\ Font
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

" highlights search results immediately
set incsearch
set hlsearch

" Monokai settings ----------------------------- {{{
" If you are using a font which support italic, you can use below config to enable the italic form
let g:monokai_italic = 1

" colorscheme
colorscheme monokai
" }}}

" color of find result background
highlight Search guibg='#4A3F2D' guifg='NONE'

"  colors of matching parens
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
hi CursorLine guibg=#23241E
hi CursorLineNr guifg=#68705e guibg=#131411

" colors and appearance of window split column
set fillchars+=vert:│
hi VertSplit guibg=#131411 guifg=#131411

" NERDTree highlight by filetypes settings ----------------------------- {{{
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd augroup_nerdtree FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guifg='. a:guifg . ' guibg=' . a:guibg
    exec 'autocmd augroup_nerdtree FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', 'NONE')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', 'NONE')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', 'NONE')
call NERDTreeHighlightFile('scss', 'cyan', 'none', 'cyan', 'NONE')
call NERDTreeHighlightFile('js', 'red', 'none', '#ffa500', 'NONE')

" Also, turn off 'Press ? for help' label
let NERDTreeMinimalUI=1
" }}}

" show invisible chars
if has("win32") || has("win16")
    set listchars=tab:⁞\ ,trail:·,extends:»,precedes:«,conceal:_,nbsp:•
else
    set listchars=tab:↳\ ,trail:·,extends:»,precedes:«,conceal:_,nbsp:•
endif
set list

" show wrapped line marker
set showbreak=»

" }}}





" Keyboard settings ============================= {{{
" =ss4=sskeyboard=

let mapleader = "\<space>"
nmap <space> <leader>
vmap <space> <leader>
xmap <space> <leader>

nmap <leader>lkk <leader>lkiW

" fast open/reload vimrc
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" Avoid accidental hits of <F1> while aiming for <Esc>
map <F1> <Esc>

" Make moving in line a bit more convenient
nnoremap 0 ^
nnoremap ^ 0
nnoremap 00 0
nnoremap $ g_
nnoremap $$ $
vnoremap 0 ^
vnoremap ^ 0
vnoremap 00 0
vnoremap $ g_
vnoremap $$ $

" fast save file, close file
nmap <leader>w :w!<cr>
nmap <leader>q <Plug>Kwbd

" new empty buffer
nmap <leader>x :enew<cr>

" return to normal mode by double-j, cyrillic double-о
inoremap jj <Esc>
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

" NERDTree mappings
map <F2> :NERDTreeToggle<CR>
nmap <leader>tt :NERDTreeFind<CR>

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

" center find results
" zv unfolds any fold if the cursor suddenly appears inside a fold.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

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
"
nnoremap <leader>; mqg_a;<esc>`q
nnoremap <leader>, mqg_a,<esc>`q

" type ':S<cr>' to split current buffer to right, and leave it with previous buffer
command! S vs | wincmd h | bprev | wincmd l

" Toggle true/false
nnoremap <silent> <C-t> mmviw:s/true\\|false/\={'true':'false','false':'true'}[submatch(0)]/<CR>`m:nohlsearch<CR>

" toggle foldColumn: 0->6->12->0...
nnoremap <leader>f :let &l:foldcolumn = (&l:foldcolumn + 6) % 18<cr>

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

abbr pt PropTypes
abbr tp this.props
abbr ts this.state
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

autocmd au_vimrc FileType help nnoremap <Esc> :q<cr>

" }}}





" Functions ============================= {{{
" =ss5=ssfunctions=

" toggle centering cursor ----------------------------- {{{
nnoremap <leader>c :call ReadModeToggle()<cr>

" TODO: scrolloff can't be local :(
let g:scrolloff_value = &scrolloff
function! ReadModeToggle()
    if &scrolloff > 10
        let &scrolloff = g:scrolloff_value
        set virtualedit=block
    else 
        let g:scrolloff_value = &scrolloff
        set scrolloff=999
        set virtualedit=all
    endif
endfunction
" }}}

" nnoremap Y y$ but in YankRing-compatible way: ----------- {{{
function! YRRunAfterMaps()
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
" }}}

" Toggle quickfix/location window ----------------------------- {{{
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
" }}}

" Kwbd ----------------------------- {{{
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
" }}}



" Skip quickfix on traversing buffers ----------------------------- {{{
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

" make gd to work with import ----------------------------- {{{
" TODO: make gd to work correctly :)
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
" }}}

" Delete trailing white space on save ----------------------------- {{{
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
" }}}

" Show all 'T O D O" locations ----------------------------- {{{
" TODO: maybe there is a plugin?
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
" }}}

" <leader>?/! | Google it / Feeling lucky ----------------------------- {{{
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
" }}}

" find word under cursor ----------------------------- {{{
" TODO: use existing plugin, or make own?
function! s:globalFind(wordMatch)
    let word = ""
    if (visualmode() == 'v')
        let word = l9#getSelectedText()
    else
        let word = expand("<cword>")
    endif

    let promptString = 'Searching text: '
    if (a:wordMatch)
        let promptString = 'Searching word: '
    endif

    let searchingWord = input(promptString, word)
    if (empty(searchingWord))
        return
    endif

    let @/ = searchingWord
    set hlsearch

    let searchingWord = substitute(searchingWord, '(', '\\(', '')
    let searchingWord = substitute(searchingWord, ')', '\\)', '')

    :execute ':NERDTreeClose'
    let searchCommand = ":Ack! -S --ignore=\"tags\" "
    if (a:wordMatch)
        :execute searchCommand."-w '".searchingWord."'"
    else
        :execute searchCommand."'".searchingWord."'"
    endif
    :execute ':NERDTreeToggle'
endfunction

nnoremap <C-f> :call <SID>globalFind(0)<cr>
xnoremap <C-f> :call <SID>globalFind(0)<cr>
nnoremap <C-f><C-f> :call <SID>globalFind(1)<cr>
xnoremap <C-f><C-f> :call <SID>globalFind(1)<cr>

" find/replace in current project 
if has("win32") || has("win16")
"   Plugin 'henrik/vim-qargs' needed for next line
    nnoremap <M-h> :Qdo %s/<C-r>f//gce\|update<left><left><left><left><left><left><left><left><left><left><left><C-r>f
else
"   Plugin 'henrik/vim-qargs' needed for next line
    nnoremap <M-h> :Qdo %s/\<<C-r>f\>//gce\|update<left><left><left><left><left><left><left><left><left><left><left><C-r>f
endif
" }}}

" -----------------------------------------------------------------------------
" Return to last edit position when opening files (You want this!)
autocmd au_vimrc BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

" Close empty buffer on leave
autocmd au_vimrc BufLeave *
    \ if line('$') == 1 && getline(1) == '' && expand('%:t') |
    \     exe 'Kwbd' |
    \ endif

autocmd au_vimrc BufWrite *.js :call DeleteTrailingWS()
" }}}

" }}}
