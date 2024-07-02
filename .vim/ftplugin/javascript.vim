vim9script

import '../autoload/trailingspace.vim'

augroup au_vimrc_js
    autocmd!
augroup END

var indent = 2
execute 'setlocal tabstop=' .. indent
execute 'setlocal softtabstop=' .. indent
execute 'setlocal shiftwidth=' .. indent

autocmd au_vimrc_js BufWrite *.js :vim9cmd trailingspace.DeleteTrailingWS()

# make Vim recognize ES6 import statements
&l:include = 'from\|require'

# make Vim use ES6 export statements as define statements
&l:define = '\v(export\s+(default\s+)?)?(var|let|const|function|class)|export\s+'
