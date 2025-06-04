vim9script

# remove all commands on re-read .vimrc file
augroup au_vimrc
    autocmd!
augroup END

# Match HTML tags
runtime macros/matchit.vim

# Return to last edit position when opening files (You want this!)
autocmd au_vimrc BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

# Close empty buffer on leave
autocmd au_vimrc BufLeave *
    \ if line('$') == 1 && getline(1) == '' && !expand('%:t') && &ft != 'qf' |
    \     exe 'kwbd#Kwbd(1)' |
    \ endif


# close vim if only window is NERDTree
autocmd au_vimrc BufEnter *
    \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
    \   | q
    \ | endif

# When switching buffers, preserve window view.
autocmd BufLeave * winview#AutoSaveWinView()
autocmd BufEnter * winview#AutoRestoreWinView()

autocmd BufRead,BufNewFile *.qf set filetype=qf

autocmd BufRead,BufNewFile *.styl set filetype=css

def MaybeRunNERDTree(): void
    if (&diff == false && argc() == 0)
        if (getline(1) =~ "^diff --git")
            set filetype=diff
            set foldlevel=999
            nnoremap q <CMD>q<CR>
        else
            NERDTree
            wincmd l
            Startify
        endif
    elseif (!get(g:, 'runClearWindow'))
        NERDTree
        wincmd l 
    endif
enddef
autocmd VimEnter * MaybeRunNERDTree()

augroup autoupdate_on_vimagit
    autocmd!
    autocmd User VimagitUpdateFile checktime
augroup END

# fugitive tormoz: when go to fugitive buffer - these plugins
# hang up all vim
# Plug 'pangloss/vim-javascript'
# Plug 'MaxMEllon/vim-jsx-pretty'
# set foldmethod to avoid it
var savedFoldMethod = ''
def CustomFixFoldMethod(): void
    augroup au_vimrc_foldmethod
        autocmd!
        savedFoldMethod = &foldmethod
        autocmd BufEnter * {
            if (bufname('%') =~ 'fugitive')
                exe 'setlocal foldmethod=manual'
            endif
        }
    augroup END
enddef
autocmd VimEnter * CustomFixFoldMethod()

autocmd BufEnter quickfix IlluminatePauseBuf

autocmd BufEnter * timer_start(1, (id) => findcursor#FindCursor('#d6d8fa', 0))

autocmd au_vimrc VimResized * :wincmd =

def FoldDiffFiles()
  setlocal foldmethod=expr
  setlocal foldexpr=getline(v:lnum)=~'^diff\\s'?'>1':1
  setlocal foldtext=getline(v:foldstart)
enddef

autocmd FileType gitcommit,diff FoldDiffFiles()

# =========
# Configuration
var old_color = '#333333'     # Dark grey for >1 month
var recent_color = '#ffff00'  # Yellow for <1 week
var default_bg = synIDattr(hlID('Normal'), 'bg#')
if default_bg == ''
    default_bg = '#ffffff'  # Fallback to white if no bg detected
endif

# Buffer-local storage for matches and state
var blame_cache = {}  # Keys: bufnr, Values: {matches: list<number>, mtime: number}

# Define highlight groups
def SetupHighlightGroups()
    execute 'highlight OldHighlight guibg=' .. old_color
    execute 'highlight RecentHighlight guibg=' .. recent_color
enddef

# Check if buffer is a regular file with git history
def IsGitFile(bufnr: number): bool
    var bufname = bufname(bufnr)
    if empty(bufname) || !filereadable(bufname) || getbufvar(bufnr, '&buftype') != ''
        return false
    endif
    
    # Check if in git repo
    var git_dir = systemlist('git -C ' .. shellescape(fnamemodify(bufname, ':h')) .. 
                \ ' rev-parse --git-dir 2>/dev/null')[0]
    if v:shell_error != 0
        return false
    endif
    
    # Check if file is tracked
    var relpath = fnamemodify(bufname, ':.')
    var tracked = systemlist('git -C ' .. shellescape(fnamemodify(bufname, ':h')) .. 
                           \ ' ls-files --error-unmatch ' .. shellescape(relpath) .. ' 2>/dev/null')
    return v:shell_error == 0
enddef

# Parse git blame output and return timestamps for each line
def GetBlameTimestamps(bufnr: number): list<number>
    var bufname = bufname(bufnr)
    var timestamps = []
    var blame_output = systemlist('git -C ' .. shellescape(fnamemodify(bufname, ':h')) .. 
                      \ ' blame --line-porcelain ' .. shellescape(fnamemodify(bufname, ':t')))
    
    for line in blame_output
        if line =~ '^author-time '
            var timestamp = str2nr(split(line)[1])
            timestamps->add(timestamp)
        endif
    endfor
    
    return timestamps
enddef

# Convert Unix timestamp to days ago
def TimestampToDaysAgo(timestamp: number): number
    var now = localtime()
    var then = strptime('%s', string(timestamp))
    return (now - then) / (24 * 60 * 60)
enddef

# Apply color to lines based on git blame age
def ApplyLineColor()
    SetupHighlightGroups()

    var bufnr = bufnr()
    var bufname = bufname(bufnr)
    var current_mtime = getftime(bufname)

    # Check if we have cached highlights for this buffer
    if has_key(blame_cache, bufnr)
        var cache = blame_cache[bufnr]
        # If file hasn't changed, keep existing highlights
        if cache.mtime == current_mtime && !empty(cache.matches)
            return
        endif
        # Clear previous matches if they exist
        if !empty(cache.matches)
            cache.matches->foreach((_, id) => matchdelete(id))
        endif
    endif

    # Skip for non-file buffers or files without git history
    if !IsGitFile(bufnr)
        return
    endif

    var timestamps = GetBlameTimestamps(bufnr)
    if empty(timestamps)
        return
    endif

    var now = localtime()
    var one_week_ago = now - (7 * 24 * 60 * 60)
    var one_month_ago = now - (30 * 24 * 60 * 60)

    var matches = []
    for lnum in range(1, min([len(timestamps), line('$')]))
        var timestamp = timestamps[lnum - 1]  # 0-based index
        var days_ago = TimestampToDaysAgo(timestamp)

        if timestamp > one_week_ago
            # Recent change (<1 week) - yellow
            var pattern = '\%' .. lnum .. 'l^.'
            try
                var matchid = matchadd('RecentHighlight', pattern)
                matches->add(matchid)
            catch
                # Skip if highlight group doesn't exist
            endtry
        elseif timestamp < one_month_ago
            # Older change (>1 month) - dark grey
            var pattern = '\%' .. lnum .. 'l^.'
            try
                var matchid = matchadd('OldHighlight', pattern)
                matches->add(matchid)
            catch
                # Skip if highlight group doesn't exist
            endtry
        endif
    endfor

    # Cache the matches and current mtime
    blame_cache[bufnr] = {matches: matches, mtime: current_mtime}
enddef

# Clean up matches when buffer is deleted
def CleanUpBuffer(bufnr: number)
    if has_key(blame_cache, bufnr)
        var cache = blame_cache[bufnr]
        if !empty(cache.matches)
            cache.matches->foreach((_, id) => matchdelete(id))
        endif
        blame_cache->remove(bufnr)
    endif
enddef

# Auto-commands to apply the effect
# augroup BlameHighlights
#     autocmd!
#     autocmd BufEnter * ApplyLineColor()
#     autocmd BufWritePost * ApplyLineColor()  # Update after saving
#     autocmd BufDelete * CleanUpBuffer(expand('<abuf>')->str2nr())
# augroup END
