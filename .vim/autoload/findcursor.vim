" make single-line code to blocked

let s:cursorline = 0
let s:cursorcolumn = 0
let s:cursorlineBg = ''
let s:cursorcolumnBg = ''

" Like windo but restore the current window.
function! WinDo(command)
  let currwin=winnr()
  execute 'windo ' . a:command
  execute currwin . 'wincmd w'
endfunction
com! -nargs=+ -complete=command Windo call WinDo(<q-args>)

function! s:ReturnHighlightTerm(group, term) abort
   " Store output of group to variable
   let output = execute('hi ' . a:group)

   " Find the term we're looking for
   return matchstr(output, a:term.'=\zs\S*')
endfunction

function! s:SaveSettings() abort
  let s:cursorline = &cursorline
  let s:cursorcolumn = &cursorcolumn
  let s:cursorlineBg = s:ReturnHighlightTerm('CursorLine', 'guibg')
  let s:cursorcolumnBg = s:ReturnHighlightTerm('CursorColumn', 'guibg')
  let s:indentEnabled = g:indentLine_enabled
endfunction

function! s:RestoreSettings() abort
  Windo let &cursorline = s:cursorline
  Windo let &cursorcolumn = s:cursorcolumn
  execute 'highlight CursorLine guibg='.s:cursorlineBg
  execute 'highlight CursorColumn guibg='.s:cursorcolumnBg
  IlluminationEnable
  if (s:indentEnabled)
      IndentLinesEnable
  endif
endfunction

function! findcursor#FindCursor(withHighlight) abort
  call <sid>SaveSettings()

  Windo set nocursorline
  Windo set nocursorcolumn
  setlocal cursorline
  setlocal cursorcolumn
  if (a:withHighlight)
    highlight CursorLine guibg=#5F0000
    highlight CursorColumn guibg=#5F0000
  " highlight CursorColumn guibg=#fc03be
  endif
  IlluminationDisable
  IndentLinesDisable

  augroup findcursor
    autocmd!
    autocmd CursorMoved,CursorMovedI * call <sid>RestoreSettings() | autocmd! findcursor
  augroup END
endfunction
