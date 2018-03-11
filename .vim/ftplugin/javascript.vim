augroup au_vimrc_js
    autocmd!
augroup END

setlocal tabstop=2 softtabstop=2 shiftwidth=2

nnoremap gd :LspDefinition<cr>
nnoremap <leader>d :call JsGotoDef()<cr>
nnoremap gdd gd

autocmd au_vimrc_js BufWrite *.js :call trailingspace#DeleteTrailingWS()
autocmd au_vimrc_js FileType javascript setlocal omnifunc=lsp#complete
