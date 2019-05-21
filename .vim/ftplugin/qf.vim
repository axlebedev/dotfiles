nnoremap <silent> <buffer> dd :call removeqfitem#RemoveQFItem()<CR>
vnoremap <silent> <buffer> d :<c-u>call removeqfitem#RemoveQFItemsVisual()<CR>
