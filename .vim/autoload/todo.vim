vim9script

# Show all 'T O D O" locations
export def Todo()
    var entries = []
    for cmd in ['git grep -n -e TODO: -e FIXME: -e XXX: 2> /dev/null',
                \ 'grep -rn -e TODO: -e FIXME: -e XXX: * 2> /dev/null']
        var lines = split(system(cmd), '\n')
        if (v:shell_error != 0)
            continue
        endif
        for line in lines
            var [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1 : 3]
            add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
        endfor
        break
    endfor

    if (!empty(entries))
        setqflist(entries)
        copen
    endif
enddef
