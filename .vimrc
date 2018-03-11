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
"
" TODO: https://github.com/wincent/ferret
"
" TODO: interesting one kana/vim-arpeggio
" TODO: for 'gf' (go to file): kana/vim-gf-diff, kana/vim-gf-user
" TODO: DougBeney/pickachu - graphical color/date picker
" TODO: lambdalisue/gina.vim git plugin, many likes

" Plugin settings ============================= {{{

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
" let g:tern_show_argument_hints='on_hold'
" let g:tern#is_show_argument_hints_enabled = 1
" Plug 'ternjs/tern_for_vim', { 'do': 'npm i' }

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

let g:lsp_async_completion = 1

autocmd FileType javascript setlocal omnifunc=lsp#complete

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'typescript-language-server',
      \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'whitelist': ['typescript', 'javascript', 'javascript.jsx']
      \ })
endif

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
    \ ' --ignore-dir coverage' .
    \ ' --ignore-dir static' .
    \ ' --ignore-dir webpack' .
    \ ' --ignore-dir .happypack' .
    \ ' --ignore-dir coverage' .
    \ ' --ignore "*node_modules*"' .
    \ ' --ignore "src/modules/jsfcore/jsfiller3"' .
    \ ' --ignore "src/modules/jsfcore/ws-editor-lib"'
endif

" -----------------------------------------------------------------------------
" autoclose parens
Plug 'jiangmiao/auto-pairs'

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

let g:ctrlp_custom_ignore = '\v[\/](\.git|node_modules|static|coverage|jsfcore/jsfiller3|jsfcore/ws-editor-lib)$'

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
function! YRRunAfterMaps()
    nnoremap Y :<C-U>YRYankCount 'y$'<CR>

    vnoremap <silent> y y`]
    vmap p :<C-u>call VisualPaste()<cr>
    " replace word under cursor with last yanked
    "visualpaste#visualpaste
    nnoremap wp viw:<C-u>call visualpaste#VisualPaste()<cr>
    nnoremap <silent> p p`]
endfunction

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
" give it a try https://github.com/morhetz/gruvbox
" give it a try https://github.com/arcticicestudio/nord-vim

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
autocmd User VimagitUpdateFile normal! zz
autocmd User VimagitRefresh normal! zz

" -----------------------------------------------------------------------------
" expand selection
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Plug 'Valloric/ListToggle'
" let g:lt_location_list_toggle_map = '<leader>0'
" let g:lt_quickfix_list_toggle_map = '<leader>b'

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

Plug 'axlebedev/vim-js-fastlog'
let g:js_fastlog_prefix = '111'

Plug 'axlebedev/vim-smart-insert-tab'
Plug 'axlebedev/js-gotodef'

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
"  wrap/unwrap lists in brackets
Plug 'FooSoft/vim-argwrap'
let g:argwrap_padded_braces = '{'
let g:argwrap_tail_comma = 1

" -TEST------------------------------------------------------------------------
"  textobjects
Plug 'kana/vim-textobj-user' " dependency for below
Plug 'kana/vim-textobj-entire' " ae, ie
Plug 'kana/vim-textobj-indent' " ai, ii, aI, iI
Plug 'kana/vim-textobj-lastpat' " last search pattern a/, i/, a?, i?
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
Plug 'rhysd/conflict-marker.vim'

" -TEST------------------------------------------------------------------------
" close tags on </
Plug 'docunext/closetag.vim'

" -TEST------------------------------------------------------------------------
" Plug 'myusuf3/numbers.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" -----------------------------------------------------------------------------
call plug#end()
filetype plugin indent on
" }}}


let &rtp = &rtp . ',' . expand('~') . '/dotfiles/.vim'

" remove all commands on re-read .vimrc file
augroup au_vimrc
    autocmd!
augroup END

command! Todo call todo#Todo()

autocmd au_vimrc BufWrite *.js :call trailingspace#DeleteTrailingWS()

" Return to last edit position when opening files (You want this!)
autocmd au_vimrc BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

" Close empty buffer on leave
autocmd au_vimrc BufLeave *
    \ if line('$') == 1 && getline(1) == '' && expand('%:t') |
    \     exe 'call kwbd#Kwbd(1)' |
    \ endif

autocmd au_vimrc BufWrite *.js :call trailingspace#DeleteTrailingWS()
" }}}

" -----------------------------------------------------------------------------
" Scroll/cursor bind the current window and the previous window
command! BindBoth set scrollbind cursorbind | wincmd p | set scrollbind cursorbind | wincmd p
command! BindBothOff set noscrollbind nocursorbind | wincmd p | set noscrollbind nocursorbind | wincmd p
nnoremap <leader>bon :BindBoth<cr>
nnoremap <leader>bof :BindBothOff<cr>
