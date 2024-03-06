vim9script

import autoload '../autoload/removeqfitem.vim'
import autoload '../autoload/globalfind.vim'

nnoremap <silent> <buffer> dd <ScriptCmd>removeqfitem.RemoveQFItem()<CR>
vnoremap <silent> <buffer> d <ScriptCmd>removeqfitem.RemoveQFItemsVisual()<CR>

nnoremap <buffer> <leader>f <ScriptCmd>removeqfitem.FilterQF(0)<CR> 
xnoremap <buffer> <leader>f <ScriptCmd>removeqfitem.FilterQF(1)<CR> 

nnoremap <buffer> <silent> <leader>q <ScriptCmd>cclose<CR> 

nnoremap <buffer> <silent> <leader>rr <ScriptCmd>globalfind.ResizeQFHeight()<CR> 

setlocal cursorline
