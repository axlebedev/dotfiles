vim9script

# syntax color limit (0 for endless)
set synmaxcol=500

# enable syntax highlight
if !exists("g:syntax_on")
    syntax enable
endif

# 100 columns highlight
set colorcolumn=100

if has('gui_running')
    if has("win32") || has("win16")
        set guifont=Consolas:h10
    else
        set guifont=DroidSansMonoforPowerline\ Nerd\ Font
    endif

    set guioptions-=m  # remove menu bar
    set guioptions-=T  # remove toolbar
    set guioptions-=L  # remove left-hand scroll bar
    set guioptions-=r  # remove right-hand scroll bar

    # Maximize gvim window.
    set lines=999 columns=999
else
    # number of colors in terminal: use gui-colors, assuming terminal supports it
    set termguicolors
endif

# different cursor shapes for different terminal modes
&t_SI = "\<Esc>[6 q"
&t_SR = "\<Esc>[4 q"
&t_EI = "\<Esc>[2 q"

# highlights search results immediately
set incsearch
set hlsearch

set background=light
colorscheme PaperColor

# highlight current line number
set cursorline

# colors and appearance of window split column
set fillchars+=vert:│
set fillchars+=eob:░

# NERDTree turn off 'Press ? for help' label
execute("legacy let NERDTreeMinimalUI = 1")

# show invisible chars
if has("win32") || has("win16")
    set listchars=tab:⁞\ ,trail:·,extends:»,precedes:«,conceal:_,nbsp:•
elseif has('gui_running')
    set listchars=tab:·\ ,trail:•,extends:»,precedes:«,conceal:_,nbsp:•
else
    set listchars=tab:·\ ,trail:•,extends:»,precedes:«,conceal:_,nbsp:•
endif
set list

# show wrapped line marker
set showbreak=»

# for Plug 'RRethy/vim-illuminate'
g:Illuminate_delay = 100
g:Illuminate_ftblacklist = ['nerdtree', 'magit']
g:Illuminate_ftHighlightGroups = {
    'javascript:blacklist': [
        'Statement',
        'Noise',
        'PreProc',
        'Type',
        'jsStorageClass',
        'jsImport', 'Include'
    ]
}
