" find word under cursor

function! globalfind#FilterTestEntries() abort
    let filtered = filter(getqflist(), "bufname(v:val.bufnr) !~# 'test'")
    call setqflist(filtered)
endfunction

function! s:EsearchInner(prefill) abort
  let savedPrefill = g:esearch.prefill

  let g:esearch.prefill = a:prefill
  execute "normal \<Plug>(esearch)"

  let @/ = g:esearch.last_pattern.str

  let g:esearch.prefill = savedPrefill
endfunction

function! globalfind#Esearch() abort
  call s:EsearchInner([])
endfunction

function! globalfind#EsearchVisual() abort
  let word = l9#getSelectedText()
  call s:EsearchInner([{-> word }])
endfunction

function! globalfind#EsearchWord() abort
  call s:EsearchInner(['cword', 'last'])
endfunction
