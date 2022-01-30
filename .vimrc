" TODO: 'help' to be always in readmode
" TODO: https://github.com/Shougo/denite.nvim - wants python3 even if its ebabled
"
" TODO https://github.com/haya14busa/.vim/
" TODO: https://github.com/haya14busa/dotfiles/blob/master/.vimrc
"
" TODO: разобраться, почему не работает vip<C-v> и после этого попробовать 
" Plug 'kana/vim-niceblock'
"
" TODO: vim-easymotion потестить
" TODO: https://github.com/qpkorr/vim-bufkill вместо kwbd
"
" Plugin settings ============================= {{{
set shell=bash

filetype off

" vim-plug installation:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin(expand('~') . '/.vim/bundle')
" General purpose plugins {{{
" -----------------------------------------------------------------------------
" General purpose funcs for other plugins
Plug 'vim-scripts/l9'
" Plug 'lh-vim-lib'

" -----------------------------------------------------------------------------
" Custom submodes
Plug 'kana/vim-submode'

" -----------------------------------------------------------------------------
" Automatically create parent directories on write when don't exist already.
Plug 'pbrisbin/vim-mkdir' 

" -----------------------------------------------------------------------------
" Make '.' work on plugin commands (not all maybe)
Plug 'tpope/vim-repeat'

" -----------------------------------------------------------------------------
" autoswitch language on leave insert mode
" NOTE: собрать и установить xkb-switch  https://github.com/grwlf/xkb-switch
Plug 'lyokha/vim-xkbswitch'
let g:XkbSwitchEnabled = 1
let g:XkbSwitchSkipIMappings = {'*': ["'", '"', '[', ']', '<', '>']}

" -----------------------------------------------------------------------------
"  Start screen for vim
Plug 'mhinz/vim-startify'
let g:startify_disable_at_vimenter = 1
let g:startify_list_order = [
    \ ['   Most recent:'], 'dir',
    \ ['   Sessions:'], 'sessions',
    \ ['   Bookmarks:'], 'bookmarks',
    \ ['   Commands:'], 'commands',
    \ ['   Most recent global'], 'files',
\ ]
let g:startify_bookmarks = [ {'c': '~/.vimrc'} ]
let g:startify_commands = [':PlugUpdate', ':PlugInstall', ':CocUpdate']
let g:startify_files_number = 12
let g:startify_update_oldfiles = 1
let g:startify_change_to_dir = 0
let g:startify_custom_header = []
" remap 'o' to open file in Startify window
autocmd User Startified nmap <buffer> o <plug>(startify-open-buffers)

" -----------------------------------------------------------------------------
" NERD Tree
Plug 'scrooloose/nerdtree'
let NERDTreeDirArrows = 1 " allow it to show arrows
let NERDTreeDirArrowExpandable = '▸' 
let NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowHidden = 1 " show hidden files
let NERDTreeCascadeSingleChildDir = 0 " dont collapse singlechild dir
let NERDTreeWinSize = 50
let NERDTreeAutoDeleteBuffer = 1
" for correct Startify update items while one session
let NERDTreeHijackNetrw = 0

" -----------------------------------------------------------------------------
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
let g:fzf_preview_window = ['right:40%:hidden', 'ctrl-/']
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.5 } }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" }}} General purpose plugins

" functions plugins {{{
" -----------------------------------------------------------------------------
" Markdown live preview
Plug 'shime/vim-livedown', { 'for': 'markdown', 'do': 'sudo npm i -g livedown' }

" -----------------------------------------------------------------------------
" :Qdo
Plug 'henrik/vim-qargs'

" -----------------------------------------------------------------------------
" Commands to open browser + open specific pages on Github.
Plug 'tyru/open-browser.vim'
nmap <F3> <Plug>(openbrowser-smart-search)
vmap <F3> <Plug>(openbrowser-smart-search)

" -----------------------------------------------------------------------------
let g:ranger_map_keys = 0
Plug 'francoiscabrol/ranger.vim'

" -----------------------------------------------------------------------------
" Delete all buffers but current
Plug 'schickling/vim-bufonly'

" -----------------------------------------------------------------------------
" Execute a :command and show the output in a temporary buffer
Plug 'AndrewRadev/bufferize.vim'

" }}} functions plugins
"
" search plugins {{{

" -----------------------------------------------------------------------------
"  TODO
" Search string or pattern in folder
" Necessary to open files from quickfix
Plug 'yssl/QFEnter'
let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>', 'o']
let g:qfenter_keymap.vopen = ['<C-v>', 'i']
let g:qfenter_keymap.hopen = ['<C-s>']

" -----------------------------------------------------------------------------
" Search in project
Plug 'eugen0329/vim-esearch'

let g:esearch = {}
let g:esearch.prefill = ['cword', 'last']
let g:esearch.regex = 1
let g:esearch.case = 'smart'
let g:esearch.select_prefilled = 0
let g:esearch.live_update = 0
let g:esearch.out = 'qflist'
let g:esearch.textobj = 0
let g:esearch.root_markers = []

" -----------------------------------------------------------------------------
" Show 'n of m' result
let g:indexed_search_mappings = 0
let g:indexed_search_numbered_only = 1
let g:indexed_search_shortmess = 1
Plug 'henrik/vim-indexed-search'

" Clear highlight on cursor move
Plug 'junegunn/vim-slash'

" }}} search plugins

" appearance plugins {{{
" -----------------------------------------------------------------------------
" Color theme
" Plug 'crusoexia/vim-monokai'
Plug 'NLKNguyen/papercolor-theme'
" give it a try https://github.com/morhetz/gruvbox
" give it a try https://github.com/arcticicestudio/nord-vim

" -----------------------------------------------------------------------------
" Highlight 'f' entries
Plug 'rhysd/clever-f.vim'
let g:clever_f_smart_case = 1
let g:clever_f_across_no_line = 1
nmap ; <Plug>(clever-f-repeat-forward)

" -----------------------------------------------------------------------------
Plug 'psliwka/vim-smoothie'
let g:smoothie_base_speed = 13

" -----------------------------------------------------------------------------
" vim-airline: cute statusbar
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled=1
let g:airline_detect_spell = 0
let g:airline_detect_spelllang = 0

function! AirlineInit()
    " like default, but without keyboard layout indicator
    let g:airline_section_a = '%#__accent_bold#%{airline#util#wrap(airline#parts#mode(),0)}%#__restore__#%{airline#util#append(airline#parts#crypt(),0)}%{airline#util#append(airline#parts#paste(),0)}%{airline#util#append(airline#extensions#keymap#status(),0)}%{airline#util#append(airline#parts#spell(),0)}%{airline#util#append("",0)}%{airline#util#append(airline#parts#iminsert(),0)}'

    let g:airline_section_b = '' " dont show git branch at airline

    let g:airline_section_y = '' " dont show encoding

    " remove excess symbols from right part
    let g:airline_section_z = '%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%#__restore__# :%3v'
endfunction
autocmd User AirlineAfterInit call AirlineInit()

let g:airline#extensions#tabline#formatter = 'jsformatter'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

if has("gui_running")
    let s:isWin = has('win32') || has('win16')
    let g:airline_left_sep = s:isWin ? ' ' : ''
    let g:airline_right_sep = s:isWin ? ' ' : ''
    let g:airline_left_alt_sep = s:isWin ? ' ' : ''
    let g:airline_right_alt_sep = s:isWin ? ' ' : ''
    let g:airline_symbols.branch = s:isWin ? ' ' : ''
    let g:airline_symbols.readonly = s:isWin ? ' ' : ''
    let g:airline_symbols.linenr = s:isWin ? ' ' : ''
endif
let g:airline_theme='papercolor'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" TODO TODO
" let g:airline_theme_patch_func = 'AirlineThemePatch'
" function! AirlineThemePatch(palette)
" if g:airline_theme == 'jellybeans'
"     echom a:palette
"     " for colors in values(a:palette.inactive)
"     " let colors[3] = 245
"     " endfor
" endif
" endfunction
" }}} appearance plugins

" git plugins {{{
" -----------------------------------------------------------------------------
" Pretty work with git
Plug 'tpope/vim-fugitive'
" By default it's set bufhidden=delete in plugin source. I dont need it
autocmd BufReadPost fugitive://* set bufhidden&
Plug 'jreybert/vimagit'
autocmd User VimagitUpdateFile normal! zt
autocmd User VimagitRefresh normal! zt
autocmd FileType magit setlocal nocursorline
Plug 'rhysd/conflict-marker.vim'
Plug 'junegunn/gv.vim'

" -----------------------------------------------------------------------------
" 'gf' from a diff file
Plug 'kana/vim-gf-user'
Plug 'kana/vim-gf-diff'
" }}} git plugins

" text-edit plugins {{{
" -----------------------------------------------------------------------------
" Some more text objects
Plug 'wellle/targets.vim'
let g:targets_pairs = '()b {}c [] <>' " replace {}B to {}c

" -----------------------------------------------------------------------------
" expand selection
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <S-v> <Plug>(expand_region_shrink)

" -----------------------------------------------------------------------------
" Toggle true/false
Plug 'AndrewRadev/switch.vim'
let g:switch_mapping = "<C-t>"

" -----------------------------------------------------------------------------
"  textobjects
Plug 'kana/vim-textobj-user' " dependency for below
Plug 'kana/vim-textobj-entire' " ae, ie
Plug 'kana/vim-textobj-indent' " ai, ii, aI, iI
Plug 'kana/vim-textobj-lastpat' " last search pattern a/, i/, a?, i?
Plug 'kana/vim-textobj-line' " al, il
Plug 'kana/vim-textobj-underscore' " a_, i_
Plug 'Julian/vim-textobj-variable-segment' " Variable (CamelCase or underscore) segment text object (iv / av).
Plug 'rhysd/vim-textobj-anyblock'
Plug 'glts/vim-textobj-comment' " comment: ic, ac

" -----------------------------------------------------------------------------
Plug 'machakann/vim-highlightedyank'
let g:highlightedyank_highlight_duration = 300

" -----------------------------------------------------------------------------
Plug 'RRethy/vim-illuminate'

" -----------------------------------------------------------------------------
" Make C-a/C-x work as expected when `-` in front of number.
Plug 'osyo-manga/vim-trip'
nmap <C-a> <Plug>(trip-increment)
nmap <C-x> <Plug>(trip-decrement)

" -----------------------------------------------------------------------------
" TODO: make it work
let g:UltiSnipsSnippetDirectories=[expand('~') . '/dotfiles/.vim/UltiSnips', 'UltiSnips']
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
Plug 'SirVer/ultisnips'

" -----------------------------------------------------------------------------
"  wrap/unwrap lists in brackets
Plug 'FooSoft/vim-argwrap'
let g:argwrap_padded_braces = '{'
let g:argwrap_tail_comma = 1

" -----------------------------------------------------------------------------
" autoclose parens
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsMapSpace = 0
imap <silent> <expr> <space> pumvisible()
	\ ? "<space>"
	\ : "<c-r>=AutoPairsSpace()<cr>"
let g:AutoPairsMapBS = 0

" -----------------------------------------------------------------------------
" comment lines, uncomment lines
Plug 'tomtom/tcomment_vim'
let g:tcomment_textobject_inlinecomment = 'ix'

" -----------------------------------------------------------------------------
" Surround.
Plug 'tpope/vim-surround'

" -----------------------------------------------------------------------------
" vmap '~' for cycle through cases
Plug 'axlebedev/vim-case-change'

" }}} text-edit plugins

" js/html/css... plugins {{{
" -----------------------------------------------------------------------------
Plug 'moll/vim-node'

" -----------------------------------------------------------------------------
" Generate jsdoc easily
Plug 'heavenshell/vim-jsdoc', { 'for': 'javascript' }
let g:jsdoc_enable_es6 = 1
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_return_type = 1
let g:jsdoc_return_description = 1
let g:jsdoc_param_description_separator = ' - '

" -----------------------------------------------------------------------------
" One plugin to rule all the languages
Plug 'othree/html5.vim', { 'for': ['html', 'javascript'] }

" -----------------------------------------------------------------------------
" JavaScript bundle for vim, this bundle provides syntax and indent plugins
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
let g:javascript_enable_domhtmlcss = 1
let g:javascript_plugin_jsdoc = 1

Plug 'othree/javascript-libraries-syntax.vim', { 'for': 'javascript' }
let g:used_javascript_libs = 'underscore,react'
" Plug 'othree/es.next.syntax.vim'

" -----------------------------------------------------------------------------
" jsx support
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': 'javascript' }
let g:vim_jsx_pretty_template_tags = []
let g:vim_jsx_pretty_colorful_config = 1

" -----------------------------------------------------------------------------
" Highlight matching html tag
" forked from 'vim-scripts/MatchTag'
Plug 'axlebedev/MatchTag', { 'for': ['javascript', 'html'] }

" -----------------------------------------------------------------------------
" autoclose html tags
Plug 'alvan/vim-closetag', { 'for': ['javascript', 'html'] }
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.jsx"
" TODO: doesn't close if we use neocomplete 

" -----------------------------------------------------------------------------
" typescript
Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'

Plug 'Quramy/tsuquyomi'
let g:tsuquyomi_disable_quickfix=1

" -----------------------------------------------------------------------------
" color highlight in text
Plug 'ap/vim-css-color', { 'for': ['javascript', 'html', 'css'] }

" -----------------------------------------------------------------------------
" Highlight eslint errors
Plug 'dense-analysis/ale'
let g:ale_lint_on_save = 0
let g:ale_open_list = 0
let g:ale_change_sign_column_color = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '♿'
let g:ale_sign_warning = ''
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\}
let g:ale_javascript_eslint_executable = 'npm run lint'
let g:ale_typescript_tslint_executable = 'npm run lint'

nmap <silent> <C-m> <Plug>(ale_next_wrap)
nmap <silent> <C-n> <Plug>(ale_previous_wrap)

" -----------------------------------------------------------------------------
Plug 'neoclide/coc.nvim', { 'do': 'yarn install --frozen-lockfile', 'frozen': 1 }
let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-tabnine']
let g:coc_global_config = '/home/alex/dotfiles/coc-settings.json'

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<C-r>=SmartInsertTab()\<cr>" :
      \ coc#refresh()

inoremap <silent><expr> <S-Tab>
      \ pumvisible() ? "\<C-p>" :
      \ "\<S-Tab>"

inoremap <silent><expr> <CR>
      \ pumvisible() ? "\<C-y>" :
      \ "\<CR>"

inoremap <silent><expr> <BS>
      \ <SID>check_back_space() ? "\<C-r>=AutoPairsDelete()<CR>" : "\<C-r>=AutoPairsDelete() \<bar> coc#refresh()<CR>"

" }}} js/html/css... plugins

" homemade plugins {{{
" -----------------------------------------------------------------------------
" homemade ^^

Plug 'axlebedev/vim-js-fastlog'
let g:js_fastlog_prefix = ['%c11111', 'background:#00FF00']

Plug 'axlebedev/vim-smart-insert-tab'

Plug 'isomoar/vim-css-to-inline', { 'for': ['javascript', 'css', 'html'] }

Plug 'axlebedev/vim-gotoline-popup'
nmap <C-g> <plug>(gotoline-popup)

Plug 'axlebedev/footprints'
" let g:footprintsColor = '#38403b'
let g:footprintsEasingFunction = 'easeinout'
let g:footprintsHistoryDepth = 10
let g:footprintsExcludeFiletypes = ['magit', 'nerdtree', 'diff']

Plug 'axlebedev/where-is-cursor'
function! FindCursorHookPre() abort
    IlluminationDisable
endfunction
let g:FindCursorPre = function('FindCursorHookPre')
function! FindCursorHookPost() abort
    IlluminationEnable
endfunction
let g:FindCursorPost = function('FindCursorHookPost')
" }}} homemade plugins

" -TEST------------------------------------------------------------------------
" 'gf' from a diff file
Plug 'kana/vim-gf-user'
Plug 'kana/vim-gf-diff'

" additional bindings to NERDTree
Plug 'PhilRunninger/nerdtree-visual-selection'

" TODO: сделать чтобы работал бесшовно
" Plug 'noscript/taberian.vim'

" -TEST------------------------------------------------------------------------
" keep cursor on yank
Plug 'svban/YankAssassin.vim'

" -----------------------------------------------------------------------------
call plug#end()
filetype plugin indent on
" }}}


let &rtp = &rtp . ',' . expand('~') . '/dotfiles/.vim'

" remove all commands on re-read .vimrc file
augroup au_vimrc
    autocmd!
augroup END

" Match HTML tags
runtime macros/matchit.vim

" Return to last edit position when opening files (You want this!)
autocmd au_vimrc BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

" Close empty buffer on leave
autocmd au_vimrc BufLeave *
    \ if line('$') == 1 && getline(1) == '' && !expand('%:t') && &ft != 'qf' |
    \     exe 'call kwbd#Kwbd(1)' |
    \ endif


" close vim if only window is NERDTree
autocmd au_vimrc bufenter *
    \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) 
    \   | q
    \ | endif

" When switching buffers, preserve window view.
autocmd BufLeave * call winview#AutoSaveWinView()
autocmd BufEnter * call winview#AutoRestoreWinView()

autocmd BufRead,BufNewFile *.qf set filetype=qf

autocmd VimEnter * if (&diff == 0 && argv(0) !~# 'git.+MSG' ) | NERDTree | wincmd l | Startify | endif

augroup autoupdate_on_vimagit
    autocmd!
    autocmd User VimagitUpdateFile checktime
augroup END

autocmd TextChanged * if &buftype == 'quickfix'
\| let @/ = g:esearch.last_pattern.str
\| endif
