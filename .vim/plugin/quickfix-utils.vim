vim9script

# quickfix next
def Cn()
    Cnext
    # it should run after buffer change
    timer_start(1, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
nnoremap <silent> cn <ScriptCmd>Cn()<CR>

# quickfix prev
def Cp()
    Cprev
    # it should run after buffer change
    timer_start(1, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
nnoremap <silent> cp <ScriptCmd>Cp()<CR>

export def DeduplicateQuickfixList()
    # Dictionary to track seen files
    var seen_files = {}

    # New list to store deduplicated entries
    var new_quickfix_list = []

    # Iterate through the current quickfix list
    for entry in getqflist()
        var filepath = bufname(entry.bufnr)  # Get the file path from the entry
        if !has_key(seen_files, filepath)
            # Add the entry to the new list if the file hasn't been seen
            add(new_quickfix_list, entry)
            seen_files[filepath] = true  # Mark the file as seen
        endif
    endfor

    # Replace the quickfix list with the deduplicated list
    setqflist([], 'r', {'items': new_quickfix_list})
enddef
