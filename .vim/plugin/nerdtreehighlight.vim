vim9script

# Custom highlight group for current file in NERDTree
highlight NERDTreeCurrentFile ctermfg=Yellow ctermbg=DarkGray guifg=#FFFF00 guibg=#333333

# Track our match ID
var nerdtree_match_id = -1

def HighlightCurrentInNERDTree()
  if !exists('g:NERDTree') || !g:NERDTree.IsOpen()
    return
  endif

  # Get NERDTree window number
  var nerdtree_winnr = bufwinnr('NERD_tree_\d\+')
  if nerdtree_winnr == -1
    return
  endif

  # Save current window
  var cur_winnr = winnr()
  var current_file = expand('%:p')

  # Switch to NERDTree window
  execute $'{nerdtree_winnr}wincmd w'

  # Clear previous highlight if exists
  if nerdtree_match_id != -1
    silent! matchdelete(nerdtree_match_id)
    nerdtree_match_id = -1
  endif

  # Highlight current file if it exists
  if !empty(current_file)
    try
      # Find the file node in NERDTree
      var root = g:NERDTreeFileNode.GetRoot()
      var node = root.findNode(current_file)
      if node != null
        node.activate()
        node.putCursorHere(0, 0)
        
        # Create new match and store its ID
        nerdtree_match_id = matchadd('NERDTreeCurrentFile', 
                                   escape(node.path.str(), '\/.'),
                                   -1) # -1 = priority
      endif
    catch
      # Fallback to simple path matching
      nerdtree_match_id = matchadd('NERDTreeCurrentFile',
                                 escape(current_file, '\/.'),
                                 -1)
    endtry
  endif

  # Return to original window
  execute $'{cur_winnr}wincmd w'
enddef

# Set up autocommands
augroup NERDTreeSync
  autocmd!
  autocmd BufEnter * {
    if &filetype != 'nerdtree'
      HighlightCurrentInNERDTree()
    endif
  }
augroup END

# Optional: Mapping to manually refresh highlight
nnoremap <silent> <leader>nh :HighlightCurrentInNERDTree()<CR>
