augroup au_vimrc_js
    autocmd!
augroup END

nnoremap gd :LspDefinition<cr>
nnoremap <leader>d :call JsGotoDef()<cr>
nnoremap gdd gd

autocmd au_vimrc_js BufWrite *.js :call trailingspace#DeleteTrailingWS()
autocmd au_vimrc_js FileType javascript setlocal omnifunc=lsp#complete
