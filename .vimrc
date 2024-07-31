vim9script

# TODO: 'help' to be always in readmode
# TODO: https://github.com/Shougo/denite.nvim - wants python3 even if its ebabled
#
# TODO https://github.com/haya14busa/.vim/
# TODO: https://github.com/haya14busa/dotfiles/blob/master/.vimrc
#
# TODO: разобраться, почему не работает vip<C-v> и после этого попробовать
# Plug 'kana/vim-niceblock'
#
# TODO: vim-easymotion потестить
# TODO: https://github.com/qpkorr/vim-bufkill вместо kwbd
#
# TODO: https://github.com/liuchengxu/vim-clap 
# https://github.com/stefandtw/quickfix-reflector.vim
# https://github.com/bounceme/poppy.vim
# https://github.com/AndrewRadev/popup_scrollbar.vim
#
# TODO NERDTree plugins
#
# TODO
# https://github.com/romainl/vim-qf
# https://github.com/stefandtw/quickfix-reflector.vim
# Plugin settings ============================= {{{
set shell=bash

filetype off

packadd cfilter

# vim-plug installation:
# curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
plug#begin(expand('~') .. '/.vim/bundle')
# General purpose plugins {{{
# -----------------------------------------------------------------------------
# General purpose funcs for other plugins
Plug 'vim-scripts/l9'
# Plug 'lh-vim-lib'

# -----------------------------------------------------------------------------
# Custom submodes
Plug 'kana/vim-submode'

# -----------------------------------------------------------------------------
# Automatically create parent directories on write when don't exist already.
Plug 'pbrisbin/vim-mkdir'

# -----------------------------------------------------------------------------
# Make '.' work on plugin commands (not all maybe)
Plug 'tpope/vim-repeat'

# -----------------------------------------------------------------------------
# autoswitch language on leave insert mode
# NOTE: собрать и установить xkb-switch  https://github.com/grwlf/xkb-switch
Plug 'lyokha/vim-xkbswitch'
g:XkbSwitchEnabled = 1
g:XkbSwitchSkipIMappings = {'*': ["'", '"', '[', ']', '<', '>']}

# -----------------------------------------------------------------------------
#  Start screen for vim
Plug 'mhinz/vim-startify'
g:startify_disable_at_vimenter = 1
g:startify_lists = [
    { type: 'dir',       header: ['   MRU ' .. getcwd()] },
    { type: 'sessions',  header: ['   Sessions']       },
    { type: 'bookmarks', header: ['   Bookmarks']      },
    { type: 'commands',  header: ['   Commands']       },
    { type: 'files',     header: ['   MRU']            },
]

g:startify_bookmarks = [ { c: '~/.vimrc' } ]
g:startify_commands = [':PlugUpdate', ':PlugInstall', ':CocUpdate']
g:startify_files_number = 15
g:startify_update_oldfiles = 1
g:startify_change_to_dir = 0
g:startify_custom_header = []
# If you want numbers to start at 1 instead of 0, you could use this:
g:startify_custom_indices = map(range(1, 100), 'string(v:val)')
# remap 'o' to open file in Startify window
autocmd User Startified nmap <buffer> o <plug>(startify-open-buffers)

# -----------------------------------------------------------------------------
# NERD Tree
Plug 'scrooloose/nerdtree'
g:NERDTreeDirArrows = 1 # allow it to show arrows
g:NERDTreeDirArrowExpandable = '▸'
g:NERDTreeDirArrowCollapsible = '▾'
g:NERDTreeShowHidden = 1 # show hidden files
g:NERDTreeCascadeSingleChildDir = 0 # dont collapse singlechild dir
g:NERDTreeWinSize = 40
g:NERDTreeAutoDeleteBuffer = 1
# for correct Startify update items while one session
g:NERDTreeHijackNetrw = 0

Plug 'woelke/vim-nerdtree_plugin_open'
g:nerdtree_plugin_open_cmd = 'xdg-open'

Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
g:WebDevIconsDisableDefaultFolderSymbolColorFromNERDTreeDir = 1
g:WebDevIconsDisableDefaultFileSymbolColorFromNERDTreeFile = 1
g:NERDTreeFileExtensionHighlightFullName = 1
g:NERDTreeExactMatchHighlightFullName = 1
g:NERDTreePatternMatchHighlightFullName = 1
g:NERDTreeHighlightFolders = 1
g:NERDTreeHighlightFoldersFullName = 1

# Disable all default file highlighting
g:NERDTreeSyntaxDisableDefaultExtensions = 1
g:NERDTreeSyntaxDisableDefaultExactMatches = 1
g:NERDTreeSyntaxDisableDefaultPatternMatches = 1

var brown = 'ab6924'
var orange = 'DC4D01'
var pink = 'D370D5'
var black = '000000'
var gray = '777777'
var green = '0A5502'
var blue = '6363F7'
g:NERDTreeExtensionHighlightColor = {
    'txt': brown,
    'md': brown,
    'js': green,
    'jsx': green,
    'ts': green,
    'tsx': green,
    'cpp': green,
    'h': blue,
    'css': pink,
    'scss': pink,
}

g:NERDTreeExactMatchHighlightColor = {
    'build': black,
    'node_modules': black,
}

g:NERDTreePatternMatchHighlightColor = {
    '\.git.*': gray,
}

# -----------------------------------------------------------------------------
# additional bindings to NERDTree
Plug 'PhilRunninger/nerdtree-visual-selection'

# -----------------------------------------------------------------------------
# 'gf' from a diff file
Plug 'kana/vim-gf-user'
Plug 'kana/vim-gf-diff'

# -----------------------------------------------------------------------------
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
g:fzf_preview_window = ['right:40%:hidden', 'ctrl-/']
g:fzf_buffers_jump = 1
g:fzf_layout = { window: { 'width': 0.5, 'height': 0.5 } }
g:fzf_colors = {
    fg:      ['fg', 'Normal'],
    bg:      ['bg', 'Normal'],
    hl:      ['fg', 'Comment'],
    'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    'hl+':     ['fg', 'Statement'],
    info:    ['fg', 'PreProc'],
    border:  ['fg', 'Ignore'],
    prompt:  ['fg', 'Conditional'],
    pointer: ['fg', 'Exception'],
    marker:  ['fg', 'Keyword'],
    spinner: ['fg', 'Label'],
    header:  ['fg', 'Comment']
}

# }}} General purpose plugins

# functions plugins {{{
# -----------------------------------------------------------------------------
# Markdown live preview
Plug 'shime/vim-livedown', { 'for': 'markdown', 'do': 'sudo npm i -g livedown' }

# -----------------------------------------------------------------------------
# :Qdo
Plug 'henrik/vim-qargs'

# -----------------------------------------------------------------------------
# Commands to open browser + open specific pages on Github.
Plug 'tyru/open-browser.vim'
nmap <F3> <Plug>(openbrowser-smart-search)
vmap <F3> <Plug>(openbrowser-smart-search)

# -----------------------------------------------------------------------------
g:ranger_map_keys = 0
Plug 'francoiscabrol/ranger.vim'

# -----------------------------------------------------------------------------
# Delete all buffers but current
Plug 'schickling/vim-bufonly'

# -----------------------------------------------------------------------------
# Execute a :command and show the output in a temporary buffer
Plug 'AndrewRadev/bufferize.vim'

# }}} functions plugins
#
# search plugins {{{

# -----------------------------------------------------------------------------
#  TODO
# Search string or pattern in folder
# Necessary to open files from quickfix
Plug 'yssl/QFEnter'
g:qfenter_keymap = {}
g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>', 'o']
g:qfenter_keymap.vopen = ['<C-v>', 'i']
g:qfenter_keymap.hopen = ['<C-s>']

# -----------------------------------------------------------------------------
# Show 'n of m' result
g:indexed_search_mappings = 0
g:indexed_search_numbered_only = 1
g:indexed_search_shortmess = 1
Plug 'henrik/vim-indexed-search'

# -----------------------------------------------------------------------------
# Clear highlight on cursor move
Plug 'junegunn/vim-slash'

# }}} search plugins

# appearance plugins {{{
# -----------------------------------------------------------------------------
# Color theme
# Plug 'crusoexia/vim-monokai'
Plug 'NLKNguyen/papercolor-theme'

# -----------------------------------------------------------------------------
# Highlight 'f' entries
Plug 'rhysd/clever-f.vim'
g:clever_f_smart_case = 1
g:clever_f_across_no_line = 1
nmap ; <Plug>(clever-f-repeat-forward)

# -----------------------------------------------------------------------------
Plug 'psliwka/vim-smoothie'
g:smoothie_base_speed = 13

# -----------------------------------------------------------------------------
# vim-airline: cute statusbar
g:airline_skip_empty_sections = 1
g:airline_powerline_fonts = 0
g:airline#extensions#tabline#enabled = 1
g:airline_detect_spell = 0
g:airline_detect_spelllang = 0

def AirlineInit(): void
    # like default, but without keyboard layout indicator
    g:airline_section_a = '%#__accent_bold#%{airline#util#wrap(airline#parts#mode(),0)}%#__restore__#%{airline#util#append(airline#parts#crypt(),0)}%{airline#util#append(airline#parts#paste(),0)}%{airline#util#append(airline#extensions#keymap#status(),0)}%{airline#util#append(airline#parts#spell(),0)}%{airline#util#append("",0)}%{airline#util#append(airline#parts#iminsert(),0)}'

    g:airline_section_b = '' # dont show git branch at airline

    g:airline_section_y = '' # dont show encoding

    # remove excess symbols from right part
    g:airline_section_z = '%3p%% %#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%#__restore__# :%3v'
enddef
autocmd User AirlineAfterInit AirlineInit()

g:airline#extensions#tabline#formatter = 'jsformatter'
if !exists('g:airline_symbols')
    g:airline_symbols = {}
endif

if has('gui_running')
    var isWin = has('win32') || has('win16')
    g:airline_left_sep = isWin ? ' ' : ''
    g:airline_right_sep = isWin ? ' ' : ''
    g:airline_left_alt_sep = isWin ? ' ' : ''
    g:airline_right_alt_sep = isWin ? ' ' : ''
    g:airline_symbols.branch = isWin ? ' ' : ''
    g:airline_symbols.readonly = isWin ? ' ' : ''
    g:airline_symbols.linenr = isWin ? ' ' : ''
endif
g:airline_theme = 'papercolor'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

# TODO TODO
# g:airline_theme_patch_func = 'AirlineThemePatch'
# def AirlineThemePatch(palette): void
# if g:airline_theme == 'jellybeans'
#     echom a:palette
#     # for colors in values(a:palette.inactive)
#     # colors[3] = 245
#     # endfor
# endif
# enddef
# }}} appearance plugins

# git plugins {{{
# -----------------------------------------------------------------------------
# Pretty work with git
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
autocmd User VimagitUpdateFile normal! zt
autocmd User VimagitRefresh normal! zt
autocmd FileType magit setlocal nocursorline
Plug 'rhysd/conflict-marker.vim'
Plug 'junegunn/gv.vim'

# -----------------------------------------------------------------------------
# 'gf' from a diff file
Plug 'kana/vim-gf-user'
Plug 'kana/vim-gf-diff'
# }}} git plugins

# text-edit plugins {{{
# -----------------------------------------------------------------------------
# Some more text objects
Plug 'wellle/targets.vim'
g:targets_pairs = '()b {}c [] <>' # replace {}B to {}c

# -----------------------------------------------------------------------------
# expand selection
Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <S-v> <Plug>(expand_region_shrink)
def Exp(): void
    expand_region#custom_text_objects({
        "\/\\n\\n\<CR>": 1, # Motions are supported as well. Here's a search motion that finds a blank line
        'a]': 1, # Support nesting of 'around' brackets
        'ab': 1, # Support nesting of 'around' parentheses
        'aB': 1, # Support nesting of 'around' braces
        'ii': 0, # 'inside indent'. Available through https://github.com/kana/vim-textobj-indent
        'ai': 0, # 'around indent'. Available through https://github.com/kana/vim-textobj-indent
        'ia': 1,
        'aa': 1,
    })
enddef
au VimEnter * Exp()

# -----------------------------------------------------------------------------
# Toggle true/false
Plug 'AndrewRadev/switch.vim'
g:switch_mapping = "<C-t>"

# -----------------------------------------------------------------------------
#  textobjects
Plug 'kana/vim-textobj-user' # dependency for below
Plug 'kana/vim-textobj-entire' # ae, ie
Plug 'kana/vim-textobj-indent' # ai, ii, aI, iI
Plug 'kana/vim-textobj-lastpat' # last search pattern a/, i/, a?, i?
Plug 'kana/vim-textobj-line' # al, il
Plug 'kana/vim-textobj-underscore' # a_, i_
Plug 'Julian/vim-textobj-variable-segment' # Variable (CamelCase or underscore) segment text object (iv / av).
Plug 'rhysd/vim-textobj-anyblock'
Plug 'glts/vim-textobj-comment' # comment: ic, ac

# -----------------------------------------------------------------------------
Plug 'machakann/vim-highlightedyank'
g:highlightedyank_highlight_duration = 500
autocmd ColorScheme *
  \ highlight HighlightedyankRegion guibg=#f6b7ac

# -----------------------------------------------------------------------------
Plug 'RRethy/vim-illuminate'

# -----------------------------------------------------------------------------
# Make C-a/C-x work as expected when `-` in front of number.
Plug 'osyo-manga/vim-trip'
nmap <C-a> <Plug>(trip-increment)
nmap <C-x> <Plug>(trip-decrement)

# -----------------------------------------------------------------------------
# TODO: make it work
g:UltiSnipsSnippetDirectories = [expand('~') .. '/dotfiles/.vim/UltiSnips', 'UltiSnips']
g:UltiSnipsExpandTrigger = "<c-k>"
g:UltiSnipsJumpForwardTrigger = "<c-j>"
g:UltiSnipsJumpBackwardTrigger = "<c-k>"
Plug 'SirVer/ultisnips'

# -----------------------------------------------------------------------------
# wrap/unwrap lists in brackets
Plug 'FooSoft/vim-argwrap'
g:argwrap_padded_braces = '{'
g:argwrap_tail_comma = 1

Plug 'AndrewRadev/splitjoin.vim'
g:splitjoin_trailing_comma = 1
g:splitjoin_html_attributes_bracket_on_new_line = 1
g:splitjoin_split_mapping = 'gs'
g:splitjoin_join_mapping  = 'gj'

# -----------------------------------------------------------------------------
# autoclose parens
Plug 'jiangmiao/auto-pairs'
g:AutoPairsMapSpace = 0
g:AutoPairsMultilineClose = 0 # Dont make a mess when `{ if(condition) { doSomething [cursor] }`
imap <silent> <expr> <space> pumvisible()
	\ ? "<space>"
	\ : "<c-r>=AutoPairsSpace()<cr>"
g:AutoPairsMapBS = 0

# -----------------------------------------------------------------------------
# comment lines, uncomment lines
Plug 'tomtom/tcomment_vim'
g:tcomment_maps = 1
g:tcomment_textobject_inlinecomment = 'ix'
nnoremap <C-_> <CMD>TComment<CR>
vnoremap <C-_> :TComment<CR>gv

# -----------------------------------------------------------------------------
# Surround.
Plug 'tpope/vim-surround'

# -----------------------------------------------------------------------------
# vmap '~' for cycle through cases
Plug 'axlebedev/vim-chase'
autocmd ColorScheme *
  \ highlight CaseChangeWord guibg=#0000FF

# -----------------------------------------------------------------------------
# keep cursor on yank
Plug 'svban/YankAssassin.vim'

# }}} text-edit plugins

# js/html/css... plugins {{{
# -----------------------------------------------------------------------------
Plug 'moll/vim-node'

# -----------------------------------------------------------------------------
# Generate jsdoc easily
Plug 'heavenshell/vim-jsdoc', { 'for': 'javascript' }
g:jsdoc_enable_es6 = 1
g:jsdoc_allow_input_prompt = 1
g:jsdoc_input_description = 1
g:jsdoc_return_type = 1
g:jsdoc_return_description = 1
g:jsdoc_param_description_separator = ' - '

# -----------------------------------------------------------------------------
# One plugin to rule all the languages
Plug 'othree/html5.vim', { 'for': ['html', 'javascript', 'typescript'] }

# -----------------------------------------------------------------------------
# JavaScript bundle for vim, this bundle provides syntax and indent plugins
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
g:javascript_enable_domhtmlcss = 1
g:javascript_plugin_jsdoc = 1

Plug 'othree/javascript-libraries-syntax.vim', { 'for': 'javascript' }
g:used_javascript_libs = 'underscore,react'
# Plug 'othree/es.next.syntax.vim'

# -----------------------------------------------------------------------------
# jsx support
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': ['javascript', 'typescript'] }
g:vim_jsx_pretty_template_tags = []
g:vim_jsx_pretty_colorful_config = 1

# -----------------------------------------------------------------------------
# Highlight matching html tag
# forked from 'vim-scripts/MatchTag'
# Plug 'axlebedev/MatchTag', { 'for': ['javascript', 'html'] }

# -----------------------------------------------------------------------------
# autoclose html tags
Plug 'alvan/vim-closetag', { 'for': ['javascript', 'html'] }
g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.jsx"
# TODO: doesn't close if we use neocomplete

# -----------------------------------------------------------------------------
# typescript
Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'

# -----------------------------------------------------------------------------
# color highlight in text
Plug 'ap/vim-css-color'

# -----------------------------------------------------------------------------
# Highlight eslint errors
Plug 'dense-analysis/ale'
g:ale_lint_on_save = 0
g:ale_open_list = 0
g:ale_change_sign_column_color = 1
g:ale_sign_column_always = 1
g:ale_sign_error = '♿'
g:ale_sign_warning = ''
g:ale_set_loclist = 0
g:ale_set_quickfix = 0
g:ale_virtualtext_cursor = 0
g:ale_disable_lsp = 1

g:ale_linters = {
    javascript: ['eslint'],
    typescript: ['eslint']
}
g:ale_javascript_eslint_executable = 'npm -s run lint %'
g:ale_typescript_tslint_executable = 'npm -s run lint %'

nmap <silent> <C-m> <Plug>(ale_next_wrap)
nmap <silent> <C-n> <Plug>(ale_previous_wrap)

# -----------------------------------------------------------------------------
# Plug 'neoclide/coc.nvim', { 'do': 'yarn install --frozen-lockfile', 'tag': 'v0.0.82' }
Plug 'neoclide/coc.nvim', { 'do': 'yarn install --frozen-lockfile' }
# Чтобы не авто-выбирал первый пункт в автокомплите:
# :CocConfig -> "suggest.noselect": true
g:coc_global_extensions = [
    'coc-json',
    'coc-tsserver',
    'coc-tabnine',
    'coc-clangd',
    'coc-yaml',
    'coc-ccls',
]
g:coc_global_config = '/home/alex/dotfiles/coc-settings.json'

var filesuffix_blacklist = ['git', '']
def DisableCocForType(): void
	if index(filesuffix_blacklist, expand('%:e')) != -1
		b:coc_enabled = 0
	endif
enddef
autocmd BufRead,BufNewFile * DisableCocForType()

def CheckBackSpace(): bool
	var col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
enddef

inoremap <silent><expr> <TAB> coc#pum#visible()
  \ ? coc#pum#next(1)
  \ : <SID>CheckBackSpace()
  \     ? "\<C-r>=SmartInsertTab()\<cr>"
  \     : coc#refresh()

inoremap <silent><expr> <S-Tab> coc#pum#visible()
  \ ? coc#pum#prev(1)
  \ : "\<S-Tab>"

inoremap <silent><expr> <CR> coc#pum#visible()
  \ ? coc#_select_confirm()
  \ : "\<CR>"

inoremap <silent><expr> <BS> <SID>CheckBackSpace()
  \ ? "\<C-r>=AutoPairsDelete()<CR>"
  \ : "\<C-r>=AutoPairsDelete() \<bar> coc#refresh()<CR>"

# }}} js/html/css... plugins

# homemade plugins {{{
# -----------------------------------------------------------------------------
# homemade ^^

Plug 'axlebedev/vim-js-fastlog'
g:js_fastlog_prefix = '11111'

Plug 'axlebedev/vim-smart-insert-tab'

Plug 'isomoar/vim-css-to-inline'

Plug 'axlebedev/vim-gotoline-popup'
nmap <C-g> <plug>(gotoline-popup)

Plug 'axlebedev/footprints'
# g:footprintsColor = '#38403b'
g:footprintsEasingFunction = 'easeinout'
g:footprintsHistoryDepth = 10
g:footprintsExcludeFiletypes = ['magit', 'nerdtree', 'diff']

Plug 'axlebedev/find-my-cursor'
def FindCursorHookPre(): void
    FootprintsDisable
    IlluminationDisable
enddef
g:FindCursorPre = function('FindCursorHookPre')
def FindCursorHookPost(): void
    FootprintsEnable
    IlluminationEnable
enddef
g:FindCursorPost = function('FindCursorHookPost')

Plug 'axlebedev/vim-foldtext'
g:FoldText_expansion = '   ' 
g:FoldText_width = 0
g:FoldText_placeholder = '⋯ '
g:FoldText_multiplication = ''
g:FoldText_line = '   ▤ '
# }}} homemade plugins

# TODO: сделать чтобы работал бесшовно
# Plug 'noscript/taberian.vim'


# -----------------------------------------------------------------------------
plug#end()
filetype plugin indent on
# }}}


&rtp = &rtp .. ',' .. expand('~') .. '/dotfiles/.vim'

# remove all commands on re-read .vimrc file
augroup au_vimrc
    autocmd!
augroup END

# Match HTML tags
runtime macros/matchit.vim

# Return to last edit position when opening files (You want this!)
autocmd au_vimrc BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

# Close empty buffer on leave
autocmd au_vimrc BufLeave *
    \ if line('$') == 1 && getline(1) == '' && !expand('%:t') && &ft != 'qf' |
    \     exe 'kwbd#Kwbd(1)' |
    \ endif


# close vim if only window is NERDTree
autocmd au_vimrc bufenter *
    \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
    \   | q
    \ | endif

# When switching buffers, preserve window view.
autocmd BufLeave * winview#AutoSaveWinView()
autocmd BufEnter * winview#AutoRestoreWinView()

autocmd BufRead,BufNewFile *.qf set filetype=qf

autocmd BufRead,BufNewFile *.styl set filetype=css

def MaybeRunNERDTree(): void
    if (&diff == false && argc() == 0)
        if (getline(1) =~ "^diff --git")
            set filetype=diff
            set foldlevel=999
            nnoremap q <CMD>q<CR>
        else
            NERDTree
            wincmd l
            Startify
        endif
    elseif (!get(g:, 'runClearWindow'))
        NERDTree
        wincmd l 
    endif
enddef
autocmd VimEnter * MaybeRunNERDTree()

augroup autoupdate_on_vimagit
    autocmd!
    autocmd User VimagitUpdateFile checktime
augroup END

# fugitive tormoz: when go to fugitive buffer - these plugins
# hang up all vim
# Plug 'pangloss/vim-javascript'
# Plug 'MaxMEllon/vim-jsx-pretty'
# set foldmethod to avoid it
var savedFoldMethod = ''
def CustomFixFoldMethod(): void
    augroup au_vimrc_foldmethod
        autocmd!
        savedFoldMethod = &foldmethod
        autocmd BufEnter * {
            if (bufname('%') =~ 'fugitive')
                &foldmethod = 'manual'
            else
                &foldmethod = savedFoldMethod
            endif
        }
    augroup END
enddef
autocmd VimEnter * CustomFixFoldMethod()

autocmd BufEnter quickfix IlluminatePauseBuf

autocmd BufEnter * timer_start(1, (id) => findcursor#FindCursor('#d6d8fa', 0))
