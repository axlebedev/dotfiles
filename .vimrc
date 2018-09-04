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

filetype off

" vim-plug installation:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin(expand('~') . '/.vim/bundle')
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
let NERDTreeDirArrows=1 " allow it to show arrows
if has('gui_running')
    let NERDTreeDirArrowExpandable='▸'
    let NERDTreeDirArrowCollapsible='▾'
else 
    let NERDTreeDirArrowExpandable='+'
    let NERDTreeDirArrowCollapsible='-'
endif
let NERDTreeShowHidden=1 " show hidden files
let NERDTreeCascadeSingleChildDir=0 " dont collapse singlechild dir

" -----------------------------------------------------------------------------
" vim-airline: cute statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled=1
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

let g:airline_theme='jellybeans'
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
" jsx support
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0

" -----------------------------------------------------------------------------
" To make it work: 
" tern_for_vim/node_modules/tern/plugin/webpack.js:
" getResolver::config::modules += "src"
" let g:tern_show_argument_hints='on_hold'
" let g:tern#is_show_argument_hints_enabled = 1
" Plug 'ternjs/tern_for_vim', { 'do': 'npm i' }

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
let g:lsp_async_completion = 1

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

if executable('typescript-language-server')
    autocmd User lsp_setup call lsp#register_server({
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

" -----------------------------------------------------------------------------
" Search in project
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

if executable('ag')
    let g:ctrlp_use_caching = 0

    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" -U --hidden' .
      \ ' --ignore-dir .git' .
      \ ' --ignore-dir bin' .
      \ ' --ignore-dir logs' .
      \ ' --ignore-dir lib' .
      \ ' --ignore-dir coverage' .
      \ ' --ignore-dir .happypack' .
      \ ' --ignore-dir coverage' .
      \ ' --ignore "*\.git*"' .
      \ ' --ignore "*node_modules*"' .
      \ ' --ignore "src/modules/jsfcore/jsfiller3"' .
      \ ' --ignore "src/modules/jsfcore/ws-editor-lib"'
endif

" -----------------------------------------------------------------------------
" comment lines, uncomment lines
Plug 'tomtom/tcomment_vim'
let g:tcomment_textobject_inlinecomment = 'ix'

" -----------------------------------------------------------------------------
" Show 'n of m' result
let g:indexed_search_mappings = 0
let g:indexed_search_numbered_only = 1
let g:indexed_search_shortmess = 1
Plug 'henrik/vim-indexed-search'

" Clear highlight on cursor move
Plug 'junegunn/vim-slash'
noremap <silent> <plug>(slash-after) :ShowSearchIndex<cr>

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
"
" -----------------------------------------------------------------------------
" yank previous registers
Plug 'vim-scripts/YankRing.vim'
nnoremap <silent> <F11> :YRShow<CR>
function! YRRunAfterMaps() abort
    nnoremap Y :<C-U>YRYankCount 'y$'<CR>

    vnoremap <silent> y y`]
    vmap p pgvy
    " replace word under cursor with last yanked
    nnoremap wp viwpgvy
    nnoremap <silent> p p`]
endfunction

" -----------------------------------------------------------------------------
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_show_diagnostics_ui = 0
let g:ycm_complete_in_comments = 1
set completeopt-=preview
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : SmartInsertTab()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"

Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
if !exists("g:ycm_semantic_triggers")
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']

" -----------------------------------------------------------------------------
" typescript
Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'

Plug 'Quramy/tsuquyomi'
let g:tsuquyomi_disable_quickfix=1

" -----------------------------------------------------------------------------
" color highlight in text
Plug 'ap/vim-css-color'

" -----------------------------------------------------------------------------
" Indent line for leading spaces
Plug 'Yggdroot/indentLine'
" Warning! needed to patch font as described at https://github.com/Yggdroot/indentLine
if has("gui_running")
    let g:indentLine_char = '┆'
endif

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
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'jreybert/vimagit'
autocmd User VimagitUpdateFile normal! zt
autocmd User VimagitRefresh normal! zt
Plug 'rhysd/conflict-marker.vim'
" test, GV replacement
Plug 'gregsexton/gitv'

" -----------------------------------------------------------------------------
" expand selection
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Plug 'Valloric/ListToggle'
" let g:lt_location_list_toggle_map = '<leader>0'
" let g:lt_quickfix_list_toggle_map = '<leader>b'

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

let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\}
let g:ale_javascript_eslint_executable = 'npm run lint'
let g:ale_typescript_tslint_executable = 'npm run lint'

nmap <silent> <C-m> <Plug>(ale_next_wrap)

" -----------------------------------------------------------------------------
" Highlight 'f' entries
Plug 'rhysd/clever-f.vim'
let g:clever_f_smart_case = 1
let g:clever_f_across_no_line = 1
nmap ; <Plug>(clever-f-repeat-forward)

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
" Toggle true/false
Plug 'sagarrakshe/toggle-bool'

" -----------------------------------------------------------------------------
Plug 'machakann/vim-highlightedyank'
let g:highlightedyank_highlight_duration = 300

" -----------------------------------------------------------------------------
" homemade ^^

Plug 'axlebedev/vim-js-fastlog'
let g:js_fastlog_prefix = ['%c11111', 'background:#00FF00']

Plug 'axlebedev/vim-smart-insert-tab'
Plug 'axlebedev/js-gotodef'

Plug 'isomoar/vim-css-to-inline'

" -----------------------------------------------------------------------------
" TODO: make it work
let g:UltiSnipsSnippetDirectories=[expand('~') . '/dotfiles/.vim/UltiSnips', 'UltiSnips']
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
Plug 'SirVer/ultisnips'

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
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" -TEST------------------------------------------------------------------------
" 'gf' from a diff file
Plug 'kana/vim-gf-user'
Plug 'kana/vim-gf-diff'

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

" start NERDTree and Startify on vim startup
autocmd VimEnter * Startify | NERDTree | wincmd l

" close vim if only window is NERDTree
autocmd au_vimrc bufenter *
    \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) 
    \   | q
    \ | endif

" Don't use indentLine in diff mode
" TODO: check for background color of indentLine in diffs
function! MaybeTobbleIndentLineByDiff() 
    if (&diff)
        :IndentLinesDisable
    endif

    if (!&diff)
        :IndentLinesEnable
    endif
endfunction

autocmd BufEnter * :call MaybeTobbleIndentLineByDiff()

" When switching buffers, preserve window view.
autocmd BufLeave * call winview#AutoSaveWinView()
autocmd BufEnter * call winview#AutoRestoreWinView()
