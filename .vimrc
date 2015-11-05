set synmaxcol=150
set history=500
syntax on 
"for correct colorscheme work
set t_Co=256
set timeoutlen=300
colorscheme monokai
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta
let g:molokai_original = 1
"set background=dark

"mouse for gnome-terminal
se mouse=a

"80 columns highlight
set cc=80

nnoremap <F12> :noh<CR>
nnoremap <C-Tab> :bn<CR>
nnoremap <C-S-Tab> :bp<CR>

"vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=234
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235

"let g:pathogen_disabled = ['tagbar']
filetype off
call pathogen#helptags()
call pathogen#infect()
filetype plugin indent on     
set omnifunc=syntaxcomplete#Complete

"Fix of Esc key while autocomplete popup is visible: return to Normal mode
let g:AutoClosePumvisible = {"ENTER": "\<C-y>", "Esc": "\<C-y>\<Esc>"}

au BufNewFile,BufRead *.{md,mdown,mkd,mkdn,markdown,mdwn} set     filetype=markdown

set ruler
set number
set showcmd
set tabstop=4
set shiftwidth=4
set smarttab
set hlsearch
set ignorecase
set smartcase
set path=.,,**

set ai "включим автоотступы для новых строк
set cin "отступы в стиле си

"NERD Comment
let mapleader = ","
nnoremap <leader>c<Space> <C-_>
nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>


"NERDTree
map <C-n> :NERDTreeTabsToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeShowHidden=1
let g:nerdtree_tabs_open_on_console_startup=1
let g:nerdtree_tabs_focus_on_files=1
let g:nerdtree_tabs_autofind=1

function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
	exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
	exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')

"airline
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif


let g:airline_left_sep = ''
let g:airline_right_sep = ''
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '◀'
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"tagbar
nmap <F8> :TagbarToggle<CR>

"ctrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'


" Add support for markdown files in tagbar.
let g:tagbar_type_markdown = {
	\ 'ctagstype': 'markdown',
	\ 'ctagsbin' : '/home/alex/.vim/bundle/markdown2ctags/markdown2ctags.py',
	\ 'ctagsargs' : '-f - --sort=yes',
	\ 'kinds' : [
		\ 's:sections',
		\ 'i:images'
	\ ],
	\ 'sro' : '|',
	\ 'kind2scope' : {
		\ 's' : 'section',
	\ },
	\ 'sort': 0,
\ }

"vim-xkbswitch
let g:XkbSwitchEnabled = 1

"incsearch plugin
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
