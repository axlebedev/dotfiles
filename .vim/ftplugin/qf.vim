nnoremap <silent> <buffer> dd :call removeqfitem#RemoveQFItem()<CR>
vnoremap <silent> <buffer> d :<c-u>call removeqfitem#RemoveQFItemsVisual()<CR>

nnoremap <buffer> <leader>f :call removeqfitem#FilterQF(0)<CR> 
xnoremap <buffer> <leader>f :call removeqfitem#FilterQF(1)<CR> 
