vim9script

import '../autoload/trailingspace.vim'

augroup au_vimrc_js
    autocmd!
augroup END

setlocal tabstop=2 softtabstop=2 shiftwidth=2

autocmd au_vimrc_js BufWrite *.js :vim9cmd trailingspace.DeleteTrailingWS()

" make Vim recognize ES6 import statements
&l:include = 'from\|require'

" make Vim use ES6 export statements as define statements
&l:define = '\v(export\s+(default\s+)?)?(var|let|const|function|class)|export\s+'
