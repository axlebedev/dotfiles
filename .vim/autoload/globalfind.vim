" find word under cursor

function! globalfind#FilterTestEntries() abort
    let filtered = filter(getqflist(), "bufname(v:val.bufnr) !~# 'test'")
    call setqflist(filtered)
endfunction

function! globalfind#Esearch() abort
  let savedPrefill = g:esearch.prefill

  let g:esearch.prefill = []
  execute "normal \<Plug>(esearch)"

  let @/ = g:esearch.last_pattern.str

  let g:esearch.prefill = savedPrefill
endfunction

function! globalfind#EsearchVisual() abort
  let word = l9#getSelectedText()
  let savedPrefill = g:esearch.prefill

  let g:esearch.prefill = [{-> word }]
  execute "normal \<Plug>(esearch)"

  let @/ = g:esearch.last_pattern.str

  let g:esearch.prefill = savedPrefill
endfunction

function! globalfind#EsearchWord() abort
  let savedPrefill = g:esearch.prefill

  let g:esearch.prefill = ['cword', 'last']
  execute "normal \<Plug>(esearch)"

  let @/ = g:esearch.last_pattern.str

  let g:esearch.prefill = savedPrefill
endfunction
