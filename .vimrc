" =ss1=ssplugin=        VUNDLE
" =ss2=ssglobals=       GLOBAL CONFIGS
" =ss3=ssappearance=    APPEARANCE
" =ss4=sskeyboard=      KEY BINDINGS
" =ss5=ssfunctions=     FUNCTIONS
" TODO: 'help' to be always in readmode
" TODO: fox <C-t> if there are several values in line
" TODO: https://github.com/Shougo/denite.nvim - wants python3 even if its ebabled
"
" TODO: Plug 'nixprime/cpsm'
" TODO: Plug 'haya14busa/vim-operator-flashy'
" TODO: https://github.com/haya14busa/is.vim
"
" TODO https://github.com/haya14busa/.vim/
" TODO: https://github.com/haya14busa/dotfiles/blob/master/.vimrc
"
" TODO: если мы разместили последнюю строку по центру, ушли в другой буфер,
" вернулись - то последняя строка будет снизу. Понять, откуда и исправить
"
" TODO: git merge plugins
" https://github.com/junkblocker/patchreview-vim
" https://github.com/idanarye/vim-merginal
" https://github.com/rhysd/conflict-marker.vim
"

" TODO: разобраться, почему не работает vip<C-v> и после этого попробовать 
" Plug 'kana/vim-niceblock'
"
" TODO will133/vim-dirdiff
" TODO: machakann/vim-highlightedyank

" Plugin settings ============================= {{{
" =ss1=ssplugin=

filetype off

" vim-plug installation:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.vim/bundle')
" -----------------------------------------------------------------------------
" General purpose funcs for other plugins
Plug 'vim-scripts/l9'
" Plug 'lh-vim-lib'

" -----------------------------------------------------------------------------
" Custom submodes
Plug 'kana/vim-submode'

" -----------------------------------------------------------------------------
" Execute a :command and show the output in a temporary buffer
Plug 'AndrewRadev/bufferize.vim'

" -----------------------------------------------------------------------------
" Markdown live preview
Plug 'shime/vim-livedown', { 'do': 'npm i -g livedown' }

" -----------------------------------------------------------------------------
Plug 'moll/vim-node'

" -----------------------------------------------------------------------------
" NERD Tree
Plug 'scrooloose/nerdtree'
" TODO: read help
" start NERDTree on vim startup
augroup augroup_nerdtree
    autocmd!

    autocmd VimEnter * Startify | NERDTree | wincmd l

    " close vim if only window is NERDTree
    autocmd bufenter *
        \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) 
        \   | q
        \ | endif

    autocmd StdinReadPre * let s:std_in=1
augroup END
" some configs of NERDTree
let NERDTreeDirArrows=1 " allow it to show arrows
let NERDTreeDirArrowExpandable='▸'
let NERDTreeDirArrowCollapsible='▾'
let NERDTreeShowHidden=1 " show hidden files
let NERDTreeCascadeSingleChildDir=0 " dont collapse singlechild dir
" TODO: if need https://github.com/Xuyuanp/nerdtree-git-plugin

" -----------------------------------------------------------------------------
" vim-airline: cute statusbar at bottom
Plug 'bling/vim-airline'
let g:airline_skip_empty_sections = 1
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
" Plug 'othree/es.next.syntax.vim'
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
" To make it work: 
" 1. 'npm i' after install
" 2. tern_for_vim/node_modules/tern/plugin/webpack.js:
" getResolver::config::modules += "src"
let g:tern_show_argument_hints='on_hold'
let g:tern#is_show_argument_hints_enabled = 1
Plug 'ternjs/tern_for_vim', { 'do': 'npm i' }

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
" Necessary to open files from quickfix
Plug 'yssl/QFEnter'
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>', 'o']
let g:qfenter_keymap.vopen = ['<C-v>', 'i']
let g:qfenter_keymap.hopen = ['<C-s>']

" TODO: make fzf work with Gvim
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
"
" let g:fzf_height = '30%'
" let g:fzf_commits_log_options = '--color --graph --pretty=format:"%C(yellow)%h%Creset -%C(auto)%d%Creset %s %C(bold blue)(%cr) %Cred<%an>%Creset" --abbrev-commit'
" let g:fzf_command_prefix = 'Fzf'
" let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
" let g:fzf_history_dir = '~/.local/share/fzf-history'
"
" " FZF mappings
" " nnoremap <C-p> :FZF<CR>
" nnoremap <C-i> :FzfBuffers<CR>
" nnoremap <leader>a :FzfAg<CR>
" nnoremap <silent> <BS> :FzfHistory:<CR>
Plug 'mileszs/ack.vim'
let g:ack_apply_qmappings = 0
let g:ack_apply_lmappings = 0
if executable('ag') " sudo apt-get install silversearcher-ag
  let g:ackprg = 'ag -U' .
    \ ' --ignore-dir .git' .
    \ ' --ignore-dir bin' .
    \ ' --ignore-dir logs' .
    \ ' --ignore-dir lib' .
    \ ' --ignore-dir node_modules' .
    \ ' --ignore-dir coverage' .
    \ ' --ignore-dir static' .
    \ ' --ignore-dir webpack' .
    \ ' --ignore-dir .happypack' .
    \ ' --ignore-dir coverage'
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
let g:ctrlp_working_path_mode = 'a'
" without next block it won't ignore wildcards' paths
if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif
" clear cache on vim exit
let g:ctrlp_clear_cache_on_exit = 1
" Include current file to find entries
let g:ctrlp_match_current_file = 1

let g:ctrlp_custom_ignore = '\v[\/](\.git|node_modules|static|coverage)$'

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
let g:indexed_search_mappings = 0
let g:indexed_search_numbered_only = 1
let g:indexed_search_shortmess = 1
Plug 'henrik/vim-indexed-search'

" Clear highlight on cursor move
let g:oblique#incsearch_highlight_all = 1
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-oblique'

autocmd User Oblique ShowSearchIndex
autocmd User ObliqueStar ShowSearchIndex
autocmd User ObliqueRepeat ShowSearchIndex

highlight ObliqueCurrentMatch guibg='#1A4067'
highlight ObliqueCurrentIncSearch guibg='#1A4067'

" -----------------------------------------------------------------------------
" Make '.' work on plugin commands (not all maybe)
Plug 'tpope/vim-repeat'

" -----------------------------------------------------------------------------
" Surround.
Plug 'tpope/vim-surround'

" -----------------------------------------------------------------------------
" autoswitch language on leave insert mode
" NOTE: установить в системе xkb-switch
Plug 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1
let g:XkbSwitchIMappings = ['ru']
let g:XkbSwitchSkipIMappings = {'*': ["'", '"', '[', ']', '<', '>']}

" -----------------------------------------------------------------------------
" Highlight matching html tag
Plug 'vim-scripts/MatchTag'

" -----------------------------------------------------------------------------
" autoclose html tags
Plug 'alvan/vim-closetag'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.jsx"
" TODO: doesn't close if we use neocomplete 

" -----------------------------------------------------------------------------
" yank previous registers
Plug 'vim-scripts/YankRing.vim'
nnoremap <silent> <F11> :YRShow<CR>

" -----------------------------------------------------------------------------
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_show_diagnostics_ui = 0
set completeopt-=preview
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }

inoremap <expr><TAB> pumvisible() ?
  \ "\<C-n>" : SmartInsertTab()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

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
" :Qdo
Plug 'henrik/vim-qargs'

" -----------------------------------------------------------------------------
" Pretty work with git
" TODO: READ the fucking docs, WATCH screencasts
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'junegunn/gv.vim'

Plug 'jreybert/vimagit'
nnoremap <C-g> :Magit<CR>
autocmd User VimagitUpdateFile normal! zz
autocmd User VimagitRefresh normal! zz

" -----------------------------------------------------------------------------
" expand selection
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

Plug 'Valloric/ListToggle'
let g:lt_location_list_toggle_map = '<leader>0'
let g:lt_quickfix_list_toggle_map = '<leader>b'

" -TODO------------------------------------------------------------------------
" split-join object literals in many/one line
" let g:splitjoin_split_mapping = 'gs'
" let g:splitjoin_join_mapping = 'gj'
" let g:splitjoin_trailing_comma = 1
" Plug 'AndrewRadev/splitjoin.vim'

" -----------------------------------------------------------------------------
" Highlight eslint errors
Plug 'w0rp/ale'
let g:ale_lint_on_save = 0
let g:ale_open_list = 0
let g:ale_change_sign_column_color = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '♿'
let g:ale_sign_warning = ''
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0

let g:ale_linters = { 'javascript': ['eslint'] }
let g:ale_javascript_eslint_executable = 'npm run lint'

nmap <silent> <C-m> <Plug>(ale_next_wrap)

" -----------------------------------------------------------------------------
" homemade ^^

Plug 'alexey-broadcast/vim-js-fastlog'
let g:js_fastlog_prefix = '111'

Plug 'alexey-broadcast/vim-smart-insert-tab'

Plug 'alexey-broadcast/js-gotodef'

Plug 'isomoar/vim-css-to-inline'

" -----------------------------------------------------------------------------
" color picker window inside vim
Plug 'Rykka/colorv.vim'

" -----------------------------------------------------------------------------
"  ELM
Plug 'ElmCast/elm-vim'

" -----------------------------------------------------------------------------
"  Start screen for vim
Plug 'mhinz/vim-startify'
let g:startify_list_order = [
    \ ['   Most recent:'], 'dir',
    \ ['   Sessions:'], 'sessions',
    \ ['   Bookmarks:'], 'bookmarks',
    \ ['   Commands:'], 'commands',
    \ ['   Most recent global'], 'files',
\ ]
let g:startify_bookmarks = [ {'c': '~/.vimrc'} ]
let g:startify_commands = [':PlugUpdate', ':PlugInstall']
let g:startify_files_number = 12
let g:startify_update_oldfiles = 1
let g:startify_change_to_dir = 0
let g:startify_custom_header = []
" remap 'o' to open file in Startify window
autocmd User Startified nmap <buffer> o <plug>(startify-open-buffers)

" -----------------------------------------------------------------------------
let g:UltiSnipsSnippetDirectories=['~/.vim', 'UltiSnips']
Plug 'SirVer/ultisnips'

" let g:UltiSnipsExpandTrigger="<leader>s"
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" -----------------------------------------------------------------------------
" highlight current ex-range
Plug 'xtal8/traces.vim'

" -TEST------------------------------------------------------------------------
" Narrow Region, <leader>nr
Plug 'chrisbra/NrrwRgn'
let g:nrrw_rgn_vert = 1
let g:nrrw_topbot_leftright = 'botright'
let g:nrrw_rgn_wdth = 100

" -TEST------------------------------------------------------------------------
"  wrap/unwrap lists in brackets
Plug 'FooSoft/vim-argwrap'
let g:argwrap_padded_braces = '{'
let g:argwrap_tail_comma = 1

" -TEST------------------------------------------------------------------------
"  textobjects
Plug 'kana/vim-textobj-user' " dependency for below
Plug 'kana/vim-textobj-entire' " ae, ie
Plug 'kana/vim-textobj-indent' " ai, ii, aI, iI
Plug 'kana/vim-textobj-lastpat' " a/, i/, a?, i?
Plug 'kana/vim-textobj-line' " al, il
Plug 'kana/vim-textobj-underscore' " a_, i_

" -TEST------------------------------------------------------------------------
" Highlight 'f' entries
Plug 'rhysd/clever-f.vim'
let g:clever_f_smart_case = 1
let g:clever_f_across_no_line = 1
nmap ; <Plug>(clever-f-repeat-forward)

" -TEST------------------------------------------------------------------------
Plug 'haya14busa/vim-signjk-motion'
map gj <Plug>(signjk-j)
map gk <Plug>(signjk-k)

" -TEST------------------------------------------------------------------------
"  TODO: разобраться с конфигом: игнор ненужного. неигнор дочерних репозиториев
" Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

" -TEST------------------------------------------------------------------------
Plug 'terryma/vim-smooth-scroll'
" TODO: https://github.com/yuttie/comfortable-motion.vim
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <PageUp> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <PageDown> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

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
set wildignore+=*/node_modules*,*/bower_components/*,*/build/*,*/dist/*,*happypack/*,*/lib/*,*/coverage/*
" windows version
set wildignore+=*\\node_modules*,*\\bower_components\\*,*\\build\\*,*\\dist\\*,*happypack\\*,*\\lib\\*,*\\coverage\\*

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
set tabstop=4      " width of TAB. TODO: dont't change its value? https://www.reddit.com/r/vim/wiki/vimrctips
set expandtab      " or 'noexpandtab': if set, inputs spaces instead of tabs
set softtabstop=4  " how much spaces will be removed on backspace
set shiftwidth=4   " count of spaces for '<'/'>' commands
set shiftround     " smart indent for '<'/'>' commands
set smarttab       " insert tabs on the start of a line according to shiftwidth, not tabstop
set autoindent     " autoindents for new lines
set smartindent
au FileType javascript,scss,elm setlocal tabstop=2 softtabstop=2 shiftwidth=2

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

" set quickfix wrap
autocmd au_vimrc FileType qf setlocal nowrap

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

let g:markdown_folding = 1
" }}}





" Appearance settings ============================= {{{
" =ss3=ssappearance=

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

hi ALESignColumnWithErrors guibg=#250000

" NERDTree highlight by filetypes settings ----------------------------- {{{
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
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
else
    set listchars=tab:↳\ ,trail:·,extends:»,precedes:«,conceal:_,nbsp:•
endif
set list

" show wrapped line marker
set showbreak=»

" Diff styling
highlight diffAdded   term=bold ctermbg=black   ctermfg=green  cterm=bold guibg=#114417   guifg=white gui=none
highlight DiffAdd    term=bold         ctermbg=darkgreen ctermfg=white    cterm=bold guibg=#114417  guifg=White    gui=bold

highlight diffRemoved term=bold ctermbg=black   ctermfg=red    cterm=bold guibg=#532120     guifg=white gui=none
highlight DiffDelete term=none         ctermbg=darkblue  ctermfg=darkblue cterm=none guibg=DarkBlue   guifg=DarkBlue gui=none

highlight diffChanged term=bold ctermbg=black   ctermfg=yellow cterm=bold guibg=#995C00  guifg=white gui=none
highlight diffLine    term=bold ctermbg=magenta ctermfg=white  cterm=bold guibg=#350066 guifg=white gui=none
highlight diffFile    term=bold ctermbg=yellow  ctermfg=black  cterm=none guibg=#995C00  guifg=white gui=none
highlight DiffText   term=reverse,bold ctermbg=red       ctermfg=yellow   cterm=bold guibg=DarkRed    guifg=yellow   gui=bold
highlight DiffChange term=bold         ctermbg=black     ctermfg=white    cterm=bold guibg=Black      guifg=White    gui=bold

" }}}





" Keyboard settings ============================= {{{
" =ss4=sskeyboard=

let mapleader = "\<space>"
nmap <space> <leader>
vmap <space> <leader>
xmap <space> <leader>

" no noremap here!
nmap <leader>lkk <leader>lkiW

" fast open/reload vimrc
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Jump to matching pairs easily, with Tab
nnoremap <Tab> %
vnoremap <Tab> %

" Avoid accidental hits of <F1> while aiming for <Esc>
map <F1> <Esc>
imap <F1> <Esc>

" Make moving in line a bit more convenient
nnoremap 0 ^
nnoremap ^ 0
nnoremap 00 0
nnoremap $ g_
nnoremap $$ $
nnoremap H ^
nnoremap HH 0
nnoremap L g_
nnoremap LL $
vnoremap 0 ^
vnoremap ^ 0
vnoremap 00 0
vnoremap $ g_
vnoremap $$ $
vnoremap H ^
vnoremap HH 0
vnoremap L g_
vnoremap LL $

" fast save file, close file
nnoremap <leader>w :w!<cr>
nmap <leader>q <Plug>Kwbd

" new empty buffer
noremap <leader>x :Startify<cr>

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

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" visual select current line
nnoremap vg ^vg_

" Move a line of text using Ctrl+Alt+[jk]
nnoremap <C-M-j> mz:m+<cr>`z
nnoremap <C-M-k> mz:m-2<cr>`z
vnoremap <C-M-k> :m'<-2<cr>`>my`<mzgv`yo`z
vnoremap <C-M-j> :m'>+<cr>`<my`>mzgv`yo`z

" NERDTree mappings
map <F2> :NERDTreeToggle<CR>
nnoremap <leader>tt :NERDTreeFind<CR>

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
nnoremap <leader>; mqg_a;<esc>`q
nnoremap <leader>, mqg_a,<esc>`q

" type ':S<cr>' to split current buffer to right, and leave it with previous buffer
command! S vs | wincmd h | bprev | wincmd l

" Toggle true/false
nnoremap <silent> <C-t> mmviw:s/true\\|false/\={'true':'false','false':'true'}[submatch(0)]/<CR>`m:nohlsearch<CR>

" toggle foldColumn: 0->6->12->0...
nnoremap <silent> <F4> :let &l:foldcolumn = (&l:foldcolumn + 6) % 18<cr>

" close all other buffers
nnoremap bo :BufOnly<CR>

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
abbr retunr return

abbr pt PropTypes
abbr tp this.props
abbr ts this.state
abbr tc this.context
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

autocmd au_vimrc FileType help,qf,git nnoremap <buffer> q :q<cr>
autocmd au_vimrc FileType help,qf,git nnoremap <buffer> <Esc> :q<cr>

nnoremap <silent> <leader>a :ArgWrap<CR>

" get current highlight group under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap <M-o> <Tab>

nnoremap zl :set foldlevel=1<cr>

nnoremap <C-b> :<C-u>Gblame<cr>

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
    " replace word under cursor with last yanked
    nnoremap wp viw:<C-u>call VisualPaste()<cr>
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

" Google it / Feeling lucky ----------------------------- {{{
function! s:goog(pat, lucky)
    let q = substitute(a:pat, '["\n]', ' ', 'g')
    let q = substitute(q, '[[:punct:] ]',
                \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
    echom q
    call system(printf('xdg-open "https://www.google.com/search?%sq=%s"',
                \ a:lucky ? 'btnI&' : '', q))
endfunction

nnoremap <silent> <F3> :call <SID>goog(expand("<cword>"), 0)<cr>
xnoremap <silent> <F3> "gy:call <SID>goog(@g, 0)<cr>gv
" }}}

" find word under cursor ----------------------------- {{{
" TODO: use existing plugin, or make own?
" returns ":Ack! -S -w 'word' src/"
let g:vimrc_superglobalFind = 1
function! s:globalFind(isVisualMode, wordMatch, reactRender)
    let saved_ack_qhandler = g:ack_qhandler
    let word = ""
    if (a:isVisualMode)
        let word = l9#getSelectedText()
    else
        let word = expand("<cword>")
    endif

    let promptString = 'Searching text: '
    if (a:wordMatch)
        let promptString = 'Searching word: '
    elseif (a:reactRender)
        let promptString = 'Searching where render: '
    endif

    let searchingWord = input(promptString, word)

    if (empty(searchingWord))
        return
    endif

    let @/ = searchingWord
    set hlsearch
    let g:ack_qhandler = winnr('$') > 2 ? 'botright copen' : 'belowright copen'

    let searchingWord = substitute(searchingWord, '(', '\\(', '')
    let searchingWord = substitute(searchingWord, ')', '\\)', '')

    let searchCommand = ":Ack! -S "
    let path = g:vimrc_superglobalFind ? "." : "src/"

    if (a:wordMatch)
        :execute searchCommand."-w '".searchingWord."' ".path
    elseif (a:reactRender)
        :execute searchCommand."'<".searchingWord."\\b' ".path
    else
        :execute searchCommand."'".searchingWord."' ".path
    endif

    " следующий if - ничего функционального не несет, только делает
    " поменьше дергов когда всего одно окно (помимо NERDTree)
    if (winnr('$') > 2)
        :NERDTreeClose | NERDTree | wincmd l | wincmd j
    endif

    let g:ack_qhandler = saved_ack_qhandler
endfunction

function! s:toggleGlobalFind()
    if (g:vimrc_superglobalFind)
        let g:vimrc_superglobalFind = 0
        echo "vimrc_superglobalFind = 0"
    else
        let g:vimrc_superglobalFind = 1
        echo "vimrc_superglobalFind = 1"
    endif
endfunction

nnoremap <C-f> :call <SID>globalFind(0, 0, 0)<cr>
xnoremap <C-f> :call <SID>globalFind(1, 0, 0)<cr>
nnoremap <C-f><C-f> :call <SID>globalFind(0, 1, 0)<cr>
xnoremap <C-f><C-f> :call <SID>globalFind(1, 1, 0)<cr>
nnoremap <C-f><C-r> :call <SID>globalFind(0, 0, 1)<cr>
xnoremap <C-f><C-r> :call <SID>globalFind(1, 0, 1)<cr>
nnoremap <C-f><C-g> :call <SID>toggleGlobalFind()<cr>
xnoremap <C-f><C-g> :call <SID>toggleGlobalFind()<cr>

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
"" Change file formatting with eslint's 'fix'
function! ESLintFix()
 silent execute "!./node_modules/.bin/eslint -c ./.eslintrc --fix %"
 edit! %
endfunction

nnoremap <leader>el :call ESLintFix()<CR>

" -----------------------------------------------------------------------------
" Scroll/cursor bind the current window and the previous window
command! BindBoth set scrollbind cursorbind | wincmd p | set scrollbind cursorbind | wincmd p
command! BindBothOff set noscrollbind nocursorbind | wincmd p | set noscrollbind nocursorbind | wincmd p
nnoremap <leader>bon :BindBoth<cr>
nnoremap <leader>bof :BindBothOff<cr>
