augroup au_vimrc_js
    autocmd!
augroup END

setlocal tabstop=2 softtabstop=2 shiftwidth=2

nnoremap <leader>d <CMD>call JsGotoDef()<CR>
nnoremap gdd gd

autocmd au_vimrc_js BufWrite *.ts :call trailingspace#DeleteTrailingWS()
autocmd au_vimrc_js FileType typescript setlocal omnifunc=lsp#complete

nmap gf <Plug>NodeGotoFile
