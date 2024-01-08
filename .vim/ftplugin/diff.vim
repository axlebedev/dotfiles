vim9script

setlocal nocursorline

# DiffFold {{{
def DiffFold(lnum: number)
  var line = getline(lnum)
  if line =~ '^\(diff\|---\|+++\|@@\) '
    return 1
  elseif line[0] =~ '[-+ ]'
    return 2
  else
    return 0
  endif
enddef

setlocal foldmethod=expr foldexpr=DiffFold(v:lnum)
# }}} DiffFold

# GoToNextDiff {{{
def GoToNextDiff()
  var savedSearchReg = getreg('/')
  setreg('/', '\<diff\>')

  var savedScrollOff = &scrolloff
  set scrolloff=20
  normal nzt

  &scrolloff=savedScrollOff
  setreg('/', savedSearchReg)
enddef

map <buffer> <silent> gn <ScriptCmd>GoToNextDiff()<CR>
# }}} GoToNextDiff

# CopyWithoutStart {{{
def CopyWithoutStart()
  normal! yy
  var currentLine = getreg('+')
  var firstChar = currentLine[0]

  if (firstChar == '+' || firstChar == '-')
      currentLine = currentLine[1:]
  endif
  setreg('*', currentLine)
  setreg('+', currentLine)
enddef

nnoremap <buffer> <silent> yy <ScriptCmd>call CopyWithoutStart()<CR>

def Lal()
  var yankedText = substitute(l9#getSelectedText(), "[\n^][+-]", '\n', 'g')

  # remove starting + or -, expecting that visual LINE selection
  if (yankedText[0] == '+' || yankedText[0] == '-')
    yankedText = yankedText[1 : ]
  endif
  setreg('*', yankedText)
  setreg('+', yankedText)
enddef
vnoremap <buffer> <silent> y <CMD>call <SID>Lal()<CR>
# }}} CopyWithoutStart
