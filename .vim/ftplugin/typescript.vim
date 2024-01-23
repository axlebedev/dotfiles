vim9script

import '../autoload/trailingspace.vim'

augroup au_vimrc_js
    autocmd!
augroup END

setlocal tabstop=4 softtabstop=4 shiftwidth=4

nnoremap <leader>d <ScriptCmd>JsGotoDef()<CR>
nnoremap gdd gd

autocmd au_vimrc_js BufWrite *.ts,*.tsx :vim9cmd trailingspace.DeleteTrailingWS()
autocmd au_vimrc_js FileType typescript setlocal omnifunc=lsp#complete

nmap gf <Plug>NodeGotoFile
