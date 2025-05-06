vim9script

export def DetectIndent(): number
    # Read first 1000 lines
    var lines = getline(1, 1000)
    var found_2 = false
    var found_4 = false
    var found_8 = false

    for line in lines
        # Skip empty lines, comment lines and lines with tabs
        if line =~# '^\s*$' || line =~# '^\s*#' || line =~# '^\t'
            continue
        endif

        # Get leading spaces count
        var leading_spaces = len(matchstr(line, '^ *'))

        # Skip if not multiple of 2, 4, or 8
        if leading_spaces % 2 != 0
            continue
        endif

        # Check for specific indent sizes
        if leading_spaces % 8 == 0
            found_8 = true
        elseif leading_spaces % 4 == 0
            found_4 = true
        elseif leading_spaces % 2 == 0
            found_2 = true
        endif
    endfor

    # Return priority: 2 > 4 > 8
    if found_2
        return 2
    elseif found_4
        return 4
    elseif found_8
        return 8
    endif

    # Default to 4 if no indents found (change if needed)
    return 0
enddef
