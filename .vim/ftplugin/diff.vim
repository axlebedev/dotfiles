function! DiffFold(lnum) abort
  let line = getline(a:lnum)
  if line =~ '^\(diff\|---\|+++\|@@\) '
    return 1
  elseif line[0] =~ '[-+ ]'
    return 2
  else
    return 0
  endif
endfunction

function! GoToNextDiff() abort
  let savedSearchReg = @/
  let @/ = 'diff'
  normal n
  let @/ = savedSearchReg
endfunction

map <buffer> <silent> gn :<C-u>call GoToNextDiff()<CR>

setlocal foldmethod=expr foldexpr=DiffFold(v:lnum)
setlocal nocursorline
