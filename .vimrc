syntax enable
colorscheme monokai

set number
set showcmd

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
