vim9script

setlocal nocursorline
# setlocal foldmethod=expr
# setlocal foldexpr=getline(v:lnum)=~'^diff\\s'?'>1':1

# GoToNextDiff {{{
def GoToNextDiff()
  var savedSearchReg = getreg('/')
  setreg('/', '\<diff\>')

  var savedScrollOff = &scrolloff
  set scrolloff=20
  normal nzt

  &scrolloff = savedScrollOff
  setreg('/', savedSearchReg)
enddef

map <buffer> <silent> gn <ScriptCmd>GoToNextDiff()<CR>
# }}} GoToNextDiff

# CopyWithoutStart {{{
def CopyWithoutStart()
  normal! y

  var lines = getreg('+')->split("\n")
  var resultLines = []

  for line in lines
      var firstChar = line[0]
      if (firstChar == '+' || firstChar == '-')
          resultLines = resultLines + [line[1 : ]]
      else
          resultLines = resultLines + [line]
      endif
  endfor

  var result = resultLines->join("\n")

  setreg('*', result)
  setreg('+', result)
enddef

noremap <buffer> <silent> ys <ScriptCmd>call CopyWithoutStart()<CR>
# # }}} CopyWithoutStart
