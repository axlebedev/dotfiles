augroup au_vimrc_settings
    autocmd!
augroup END

let s:vimdir = expand("~") . "/.vim"

" english vim interface language
set langmenu=en_US
let $LANG = 'en_US'
let $PAGER='' " for open 'man' in vim https://vim.fandom.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" dont save files on change buffer
set hidden

" autoreload files when they're changed on disk
set autoread

" keep lines above/below cursor
if (&diff == 0)
    set scrolloff=5
    set sidescrolloff=15
    set sidescroll=1
endif

" where to search files to open
set path=.,,**

" lets insert-mode backspace to work everywhere
set backspace=indent,eol,start

" ignore files and folders on search
set wildignore+=*.sqp,*.log
let s:isWin = has('win32') || has('win16')
if (s:isWin)
    " *nix version
    set wildignore+=*/node_modules*,*/bower_components/*,*/build/*,*/dist/*,*happypack/*,*/lib/*,*/coverage/*
else
    " windows version
    set wildignore+=*\\node_modules*,*\\bower_components\\*,*\\build\\*,*\\dist\\*,*happypack\\*,*\\lib\\*,*\\coverage\\*
endif

" tab for command line autocomplete
set wildmenu
" fix autocompletion of filenames in command-line mode
set wildmode=list:full
set wildignorecase

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
set tabstop=4      " width of TAB.
set expandtab      " or 'noexpandtab': if set, inputs spaces instead of tabs
set softtabstop=4  " how much spaces will be removed on backspace
set shiftwidth=4   " count of spaces for '<'/'>' commands
set shiftround     " smart indent for '<'/'>' commands
set smarttab       " insert tabs on the start of a line according to shiftwidth, not tabstop
set autoindent     " autoindents for new lines

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
set shortmess-=S

" Show title for terminal vim
set title

" Override some syntaxes so things look better
autocmd au_vimrc_settings BufNewFile,BufRead .eslintrc,.babelrc setlocal syntax=json
autocmd au_vimrc_settings BufNewFile,BufRead .conkyrc setlocal syntax=python

" set filetype for 'md' files
autocmd au_vimrc_settings BufNewFile,BufReadPost *.md set filetype=markdown

" set foldmethod for vimscripts
autocmd au_vimrc_settings FileType vim setlocal foldmethod=marker colorcolumn=80

" ignore whitespace in diff mode
if &diff
    set diffopt+=iwhite
endif

" set quickfix wrap
autocmd au_vimrc_settings FileType qf setlocal nowrap

" Don't remember the last cursor position when editing commit
" messages, always start on line 1
autocmd au_vimrc_settings filetype gitcommit call setpos('.', [0, 1, 1, 0])

" Vim now also uses the selection system clipboard for default yank/paste.
if has('unnamedplus')
  " See :h 'clipboard' for details.
  set clipboard=unnamedplus,unnamed
else
  set clipboard+=unnamed
endif

let g:markdown_folding = 1

set diffopt+=internal,algorithm:patience,indent-heuristic

let g:markdown_fenced_languages = ['javascript', 'html', 'css']
