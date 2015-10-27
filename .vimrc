syntax on
"before first start do in terminal:
"silent execute export TERM=xterm-256color
"for correct colorscheme work
set t_Co=256
colorscheme monokai
let g:molokai_original = 1

filetype off
call pathogen#helptags()
call pathogen#infect()
filetype plugin indent on     

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

set ai "включим автоотступы для новых строк
set cin "отступы в стиле си

"Vundle
"set rtp+=~/.vim/bundle/vundle/
"call vundle#rc()

"репозитории на github
"Bundle 'scrooloose/nerdcommenter'
"Plugin 'The-NERD-Commenter'
"репозитории vim/scripts
"Bundle 'L9'
"git репозитории (не на github)
"Bundle 'git://git.wincent.com/command-t.git'
"локальные git репозитории(если работаете над собственным плагином)
"Bundle 'file:///Users/gmarik/path/to/plugin'

"NERD Comment
let mapleader = ","
nnoremap <leader>c<Space> <C-_>
nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>

if has("autocmd")
    au InsertEnter *
        \ if v:insertmode == 'i' |
        \   silent execute "!gnome-terminal-cursor-shape.sh ibeam" |
        \ elseif v:insertmode == 'r' |
        \   silent execute "!gnome-terminal-cursor-shape.sh underline" |
        \ endif
    au InsertLeave * silent execute "!gnome-terminal-cursor-shape.sh block"
    au VimEnter * silent execute "!gnome-terminal-cursor-shape.sh block"
    au VimLeave * silent execute "!gnome-terminal-cursor-shape.sh ibeam"
    au VimLeave * silent !echo -en "\033]0;Terminal\a" 

    au BufEnter * silent !echo -en "\033]0;VIM: %:t\a" 
endif

"airline
set laststatus=2
let g:airline_powerline_fonts=1

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

"markdown for tagbar
let g:tagbar_type_markdown = {
	\ 'ctagstype' : 'markdown',
	\ 'kinds' : [
		\ 'h:Heading_L1',
		\ 'i:Heading_L2',
		\ 'k:Heading_L3'
	\ ]
\ }
