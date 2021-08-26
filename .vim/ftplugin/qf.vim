nnoremap <silent> <buffer> dd <CMD>call removeqfitem#RemoveQFItem()<CR>
vnoremap <silent> <buffer> d <CMD>call removeqfitem#RemoveQFItemsVisual()<CR>

nnoremap <buffer> <leader>f <CMD>call removeqfitem#FilterQF(0)<CR> 
xnoremap <buffer> <leader>f <CMD>call removeqfitem#FilterQF(1)<CR> 

nnoremap <buffer> <silent> <leader>q <CMD>cclose<CR> 
