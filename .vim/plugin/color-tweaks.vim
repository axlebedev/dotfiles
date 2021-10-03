" color of find result background
highlight Search guibg='#ba91f2' guifg='NONE'

"  colors of matching parens
highlight MatchParen cterm=bold ctermbg=none ctermfg=magenta gui=bold guibg=#8C5669 guifg=NONE

" colors of fold column
highlight FoldColumn guibg=#d9d9d9 guifg=#34352E

" colors of error column
highlight SignColumn guibg=#d9d9d9
augroup ClapHighlights
  autocmd!
  autocmd User ClapOnExit highlight SignColumn guibg=#d9d9d9
  autocmd User ClapOnEnter highlight SignColumn guibg=#d9d9d9
augroup END

" " colors of line number column
highlight LineNr guibg=#d9d9d9 guifg=#34352E
"
" " highlight current line number
" highlight clear CursorLine
" highlight CursorLine guibg=#23241E
" highlight CursorColumn guibg=#23241E
highlight CursorLineNr guibg=#e4e4e4 guifg=#444444 
"
highlight VertSplit guibg=#d9d9d9 guifg=#d9d9d9
"
" " ale-vim customizations
" highlight ALESignColumnWithErrors guibg=#f92772
highlight ALEError cterm=underline guibg=#ea4c31
highlight ALEWarning cterm=underline guibg=#f0eab4
"
" " Diff styling
" highlight diffAdded term=bold ctermbg=black     ctermfg=green cterm=bold guibg=#114417 guifg=NONE gui=none
" highlight DiffAdd   term=bold ctermbg=darkgreen ctermfg=white cterm=bold guibg=#114417 guifg=NONE gui=bold
"
" highlight diffRemoved term=bold ctermbg=black    ctermfg=red      cterm=bold guibg=#532120  guifg=NONE   gui=none
" highlight DiffDelete  term=none ctermbg=darkblue ctermfg=darkblue cterm=none guibg=#532120  guifg=#532120   gui=none
"
" highlight diffChanged term=bold ctermbg=black   ctermfg=yellow cterm=bold guibg=#995C00  guifg=NONE gui=none
" highlight diffFile    term=bold ctermbg=yellow  ctermfg=black  cterm=none guibg=#995C00  guifg=NONE gui=none
" highlight diffLine    term=bold ctermbg=magenta ctermfg=white  cterm=bold guibg=#350066  guifg=NONE gui=none
"
" highlight DiffText   term=reverse,bold ctermbg=red       ctermfg=yellow   cterm=bold guibg=#191C41 guifg=NONE   gui=bold
" highlight DiffChange term=bold         ctermbg=black     ctermfg=white    cterm=bold guibg=NONE guifg=NONE
"
" " highlight yank region
" highlight HighlightedyankRegion cterm=reverse guibg=#433e30
"
" " highlight jsx customizations
" highlight jsObjectKey guifg=white
" highlight jsxElement guifg=#f92772
" highlight jsxTag guifg=#f92772
" highlight jsxPunct guifg=#f92772
" highlight jsxTagName guifg=#db880d
" highlight jsxComponentName guifg=#db880d
" highlight jsxCloseTag guifg=#f92772
" highlight jsxAttrib guifg=#A6E22D
" highlight jsxEqual guifg=white
"
" " for Plug 'RRethy/vim-illuminate'
" highlight illuminatedWord guibg=#191C41
"
" " supress tildas at empty lines
" highlight NonText guifg=bg
"
" " NERDTree highlight by filetypes settings -----------------------------
" function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg) abort
"     exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guifg='. a:guifg . ' guibg=' . a:guibg
"     exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
" endfunction
" call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', 'NONE')
" call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', 'NONE')
" call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', 'NONE')
" call NERDTreeHighlightFile('scss', 'cyan', 'none', 'cyan', 'NONE')
" call NERDTreeHighlightFile('js', 'red', 'none', '#ffa500', 'NONE')
