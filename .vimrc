syntax on
colorscheme monokai
filetype plugin indent on     

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
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"репозитории на github
"Bundle 'scrooloose/nerdcommenter'
Plugin 'The-NERD-Commenter'
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
