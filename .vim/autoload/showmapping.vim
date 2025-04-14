vim9script

# Main function to show mappings in quickfix with expanded paths
export def ShowMappingsInQuickfix(mapcmd: string)
    var output = execute('verbose ' .. mapcmd)
    var qflist = []
    var current_mapping = ''
    var last_location = ''

    for line in split(output, "\n")
        if line =~ '^\s*Last set from'
            # Extract location info
            var matches = matchlist(line, 'Last set from \(\S\+\) line \(\d\+\)')
            if len(matches) >= 3
                var filepath = fnamemodify(matches[1], ':p')
                last_location = filepath .. ':' .. matches[2]
                if current_mapping != '' && last_location != ''
                    add(qflist, {
                        filename: filepath,
                        lnum: str2nr(matches[2]),
                        text: current_mapping .. ' → ' .. last_location
                    })
                endif
            endif
        elseif line !~ '^\s*$' && line !~ '^\s*n\?noremap'
            current_mapping = substitute(line, '\s\+', ' ', 'g')
        endif
    endfor

    if !empty(qflist)
        setqflist([], 'r')
        setqflist(qflist, 'a')
        copen
    else
        echomsg 'No mapping found for: ' .. mapcmd
        setqflist([], 'r')
    endif
enddef
