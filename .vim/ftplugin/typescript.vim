vim9script

import '../autoload/trailingspace.vim'

augroup au_vimrc_js
    autocmd!
augroup END

autocmd au_vimrc_js BufWrite *.ts,*.tsx :vim9cmd trailingspace.DeleteTrailingWS()
autocmd au_vimrc_js FileType typescript setlocal omnifunc=lsp#complete

nmap gf <Plug>NodeGotoFile

nnoremap ta maea: any<Esc>`a
