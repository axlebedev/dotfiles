syntax enable
colorscheme monokai

set number
set showcmd

"Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
filetype plugin indent on     " обязательно!

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
