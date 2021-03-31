" find word under cursor

function! globalfind#FilterTestEntries() abort
    let filtered0 = filter(getqflist(), "bufname(v:val.bufnr) !~# 'test'")
    let filtered1 = filter(filtered0, "bufname(v:val.bufnr) !~# 'jsfiller3'")
    let filtered2 = filter(filtered1, "bufname(v:val.bufnr) !~# 'git'")
    let filtered3 = filter(filtered2, "bufname(v:val.bufnr) !~# 'diff'")
    call setqflist(filtered1)
endfunction

function! s:EsearchInner(prefill, textobj) abort
  let g:esearch.prefill = a:prefill
  let g:esearch.textobj = a:textobj
  execute "normal \<Plug>(esearch)"

  if (!empty(g:esearch.last_pattern) && get(g:esearch.last_pattern, 'str'))
    let @/ = g:esearch.last_pattern.str
  endif
endfunction

function! globalfind#Esearch() abort
  call s:EsearchInner([], 0)
endfunction

function! globalfind#EsearchVisual() abort
  let word = l9#getSelectedText()
  call s:EsearchInner([{-> word }], 0)
endfunction

function! globalfind#EsearchWord() abort
  call s:EsearchInner(['cword', 'last'], 'word')
endfunction
