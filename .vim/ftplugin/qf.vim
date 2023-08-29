vim9script

import autoload '../autoload/removeqfitem.vim'

nnoremap <silent> <buffer> dd <CMD>vim9cmd <SID>removeqfitem.RemoveQFItem()<CR>
vnoremap <silent> <buffer> d <CMD>vim9cmd <SID>removeqfitem.RemoveQFItemsVisual()<CR>

nnoremap <buffer> <leader>f <CMD>vim9cmd <SID>removeqfitem.FilterQF(0)<CR> 
xnoremap <buffer> <leader>f <CMD>vim9cmd <SID>removeqfitem.FilterQF(1)<CR> 

nnoremap <buffer> <silent> <leader>q <CMD>cclose<CR> 

setlocal cursorline
