vim9script

export def EslintToQuickfix(cmd: string)
  var output = system(cmd)

  var qflist = []
  var regex = '\v(Error|Warning)'

  for line in split(output, "\n")
    if line =~# regex
      var parts = split(line, ':')
      var filename = parts[0]
      var other = parts[1 : ]->join('')

      var linenr = matchlist(other, '\vline (\d+)')[1]
      var colnr = matchlist(other, '\vcol (\d+)')[1]
      var text = matchlist(other, '\vcol \d+, (.*)')[1]

      qflist->add({
        filename: filename,
        lnum: linenr->str2nr(),
        col: colnr->str2nr(),
        text: text->trim(),
        type: line =~# ' error:' ? 'E' : 'W' })
    endif
  endfor

  setqflist([], ' ', { items: qflist, title: 'ESLint Errors' })
enddef
