augroup au_vimrc_js
    autocmd!
augroup END

setlocal tabstop=2 softtabstop=2 shiftwidth=2

nnoremap <leader>d :call JsGotoDef()<cr>

autocmd au_vimrc_js BufWrite *.js :call trailingspace#DeleteTrailingWS()

" make Vim recognize ES6 import statements
let &l:include = 'from\|require'

" make Vim use ES6 export statements as define statements
let &l:define = '\v(export\s+(default\s+)?)?(var|let|const|function|class)|export\s+'
