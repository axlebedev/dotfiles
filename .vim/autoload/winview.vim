vim9script

# Save current view settings on a per-window, per-buffer basis.
export def AutoSaveWinView()
    if (!exists("w:SavedBufView"))
        w:SavedBufView = {}
    endif
    w:SavedBufView[bufnr("%")] = winsaveview()
enddef

# Restore current view settings.
export def AutoRestoreWinView()
    var buf = bufnr("%")
    if (exists("w:SavedBufView") && has_key(w:SavedBufView, buf))
        var v = winsaveview()
        var atStartOfFile = v.lnum == 1 && v.col == 0
        if (atStartOfFile && !&diff)
            winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
enddef
