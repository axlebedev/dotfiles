augroup au_vimrc_js
    autocmd!
augroup END

setlocal tabstop=2 softtabstop=2 shiftwidth=2

nnoremap <leader>d :call JsGotoDef()<cr>

autocmd au_vimrc_js BufWrite *.js :call trailingspace#DeleteTrailingWS()
autocmd au_vimrc_js FileType javascript setlocal omnifunc=lsp#complete
autocmd au_vimrc_js FileType javascript.jsx set ft=javascript
