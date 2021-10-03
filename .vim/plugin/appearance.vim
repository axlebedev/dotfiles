" syntax color limit (0 for endless)
set synmaxcol=500

" enable syntax highlight
if !exists("g:syntax_on")
    syntax enable
endif

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
    set guioptions-=r  "remove right-hand scroll bar

    " Maximize gvim window.
    set lines=999 columns=999
else
    " number of colors in terminal: use gui-colors, assuming terminal supports it
    set termguicolors
endif "has('gui_running')

" different cursor shapes for different terminal modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" highlights search results immediately
set incsearch
set hlsearch

" Monokai settings ----------------------------- {{{
" If you are using a font which support italic, you can use below config to enable the italic form
" let g:monokai_italic = 1

" colorscheme
" colorscheme monokai

set background=light
colorscheme PaperColor
" }}}

" highlight current line number
set cursorline

" colors and appearance of window split column
if has('gui_running')
    set fillchars+=vert:│
endif

" NERDTree turn off 'Press ? for help' label
let NERDTreeMinimalUI=1

" show invisible chars
if has("win32") || has("win16")
    set listchars=tab:⁞\ ,trail:·,extends:»,precedes:«,conceal:_,nbsp:•
elseif has('gui_running')
    set listchars=tab:·\ ,trail:·,extends:»,precedes:«,conceal:_,nbsp:•
else
    set listchars=tab:·\ ,trail:·,extends:»,precedes:«,conceal:_,nbsp:•
endif
set list

" show wrapped line marker
set showbreak=»

" for Plug 'RRethy/vim-illuminate'
let g:Illuminate_delay = 100
let g:Illuminate_ftblacklist = ['nerdtree', 'magit']
let g:Illuminate_ftHighlightGroups = {
    \ 'javascript:blacklist': [
    \   'Statement',
    \   'Noise',
    \   'PreProc',
    \   'Type',
    \   'jsStorageClass',
    \   'jsImport', 'Include'
    \ ]
    \ }
