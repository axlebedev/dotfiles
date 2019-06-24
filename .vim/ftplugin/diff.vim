setlocal nocursorline

" DiffFold {{{
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

setlocal foldmethod=expr foldexpr=DiffFold(v:lnum)
" }}} DiffFold

" GoToNextDiff {{{
function! GoToNextDiff() abort
  let savedSearchReg = @/
  let @/ = '\<diff\>'

  let savedScrollOff = &scrolloff
  set scrolloff=20
  normal nzt

  let &scrolloff=savedScrollOff
  let @/ = savedSearchReg
endfunction

map <buffer> <silent> gn :<C-u>call GoToNextDiff()<CR>
" }}} GoToNextDiff

" CopyWithoutStart {{{
function! CopyWithoutStart() abort
  normal! yy
  let currentLine = @+
  let firstChar = currentLine[0]

  if (firstChar == '+' || firstChar == '-')
      let currentLine = currentLine[1:]
  endif
  let @* = currentLine
  let @+ = currentLine
endfunction

nnoremap <buffer> <silent> yy :<C-u>call CopyWithoutStart()<CR>
" }}} CopyWithoutStart
