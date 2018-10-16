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

    " Maximize gvim window.
    set lines=999 columns=999
else
    " number of colors in terminal
    set t_Co=256
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
let g:monokai_italic = 1

" colorscheme
colorscheme monokai
" }}}

" color of find result background
highlight Search guibg='#4A3F2D' guifg='NONE'

"  colors of matching parens
highlight MatchParen cterm=bold ctermbg=none ctermfg=magenta gui=bold guibg=#8C5669 guifg=NONE

" colors of fold column
highlight FoldColumn guibg=#131411 guifg=#34352E

" colors of error column
highlight SignColumn guibg=#131411

" colors of line number column
highlight LineNr guibg=#131411 guifg=#34352E

" highlight current line number
set cursorline
highlight clear CursorLine
highlight CursorLine guibg=#23241E
highlight CursorLineNr guifg=#68705e guibg=#131411

" colors and appearance of window split column
if has('gui_running')
    set fillchars+=vert:│
endif

highlight VertSplit guibg=#131411 guifg=#131411

highlight ALESignColumnWithErrors guibg=#250000

" NERDTree highlight by filetypes settings ----------------------------- {{{
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg) abort
    exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guifg='. a:guifg . ' guibg=' . a:guibg
    exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
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
elseif has('gui_running')
    set listchars=tab:·\ ,trail:·,extends:»,precedes:«,conceal:_,nbsp:•
endif
set list

" show wrapped line marker
set showbreak=»

" Diff styling
highlight diffAdded term=bold ctermbg=black     ctermfg=green cterm=bold guibg=#114417 guifg=NONE gui=none
highlight DiffAdd   term=bold ctermbg=darkgreen ctermfg=white cterm=bold guibg=#114417 guifg=NONE gui=bold

highlight diffRemoved term=bold ctermbg=black    ctermfg=red      cterm=bold guibg=#532120  guifg=NONE   gui=none
highlight DiffDelete  term=none ctermbg=darkblue ctermfg=darkblue cterm=none guibg=#532120  guifg=#532120   gui=none

highlight diffChanged term=bold ctermbg=black   ctermfg=yellow cterm=bold guibg=#995C00  guifg=NONE gui=none
highlight diffFile    term=bold ctermbg=yellow  ctermfg=black  cterm=none guibg=#995C00  guifg=NONE gui=none
highlight diffLine    term=bold ctermbg=magenta ctermfg=white  cterm=bold guibg=#350066  guifg=NONE gui=none

highlight DiffText   term=reverse,bold ctermbg=red       ctermfg=yellow   cterm=bold guibg=#191C41 guifg=NONE   gui=bold
highlight DiffChange term=bold         ctermbg=black     ctermfg=white    cterm=bold guibg=NONE guifg=NONE

" highlight yank region
highlight HighlightedyankRegion cterm=reverse guibg=#433e30
