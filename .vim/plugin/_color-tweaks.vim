vim9script
 
highlight SpellBad term=bold ctermbg=red  guibg=#532120 guifg=NONE gui=none

highlight PmenuThumb guibg=#999999

highlight link ChaseChangedLetter DiffAdd
highlight link ChaseSeparator DiffChange

# for 'defined but never used' warnings
highlight Conceal guifg=NONE guibg=#f6b7ac

# color of Visual selection
highlight Visual guibg=#ADCBFF guifg='NONE'

# color of find result background
# highlight QuickFixLine guibg=#B7CBED 
highlight QuickFixLine guibg=#B1d2E8 
highlight Search guibg=#ba91f2 guifg='NONE'
highlight clear IncSearch
highlight IncSearch guibg=#ba91f2 guifg='NONE'

highlight HighlightedyankRegion guibg=#acde95

#  colors of matching parens
highlight MatchParen cterm=bold ctermbg=none ctermfg=magenta gui=bold guibg=#FDBED4 guifg=NONE

# colors of fold column
highlight FoldColumn guibg=#d9d9d9 guifg=#34352E

highlight Folded guibg=#e4e4e4

# colors of error column
highlight SignColumn guibg=#d9d9d9
augroup ClapHighlights
  autocmd!
  autocmd User ClapOnExit highlight SignColumn guibg=#d9d9d9
  autocmd User ClapOnEnter highlight SignColumn guibg=#d9d9d9
augroup END

# color of Plug 'RRethy/vim-illuminate'
augroup illuminate_augroup
    autocmd!
    autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline guibg=#D6E3E9
augroup END

# colors of line number column
highlight LineNr guibg=#d9d9d9 guifg=#34352E
highlight CursorLineNr guibg=#e4e4e4 guifg=#444444 
 
highlight VertSplit guibg=#d9d9d9 guifg=#d9d9d9
 
# ale-vim customizations
highlight ALESignColumnWithErrors guibg=#f6b7ac
highlight ALEError cterm=underline guibg=#f6b7ac
highlight ALEWarning cterm=underline guibg=#f0eab4

# Diff styling
highlight diffAdded term=bold ctermbg=black     ctermfg=green cterm=bold guibg=#d0f2d4 guifg=NONE gui=none
highlight DiffAdd   term=bold ctermbg=darkgreen ctermfg=white cterm=bold guibg=#d0f2d4 guifg=NONE gui=bold
highlight GitSignsAdd guifg=#b1f5b9 guibg=#b1f5b9 

highlight diffRemoved term=bold ctermbg=black    ctermfg=red      cterm=bold guibg=#f2d1ce  guifg=NONE   gui=none
highlight DiffDelete  term=none ctermbg=darkblue ctermfg=darkblue cterm=none guibg=#f2d1ce  guifg=NONE   gui=none
highlight GitSignsDelete guifg=#f2b7b1 guibg=#f2b7b1 

highlight DiffChange term=bold ctermbg=black   ctermfg=yellow cterm=bold guibg=#ebdfce  guifg=NONE gui=none
highlight diffChanged term=bold ctermbg=black   ctermfg=yellow cterm=bold guibg=#ebdfce  guifg=NONE gui=none
highlight GitSignsChange guifg=#ffe79f guibg=#ffe79f 
highlight diffFile    term=bold ctermbg=yellow  ctermfg=black  cterm=none guibg=#ebdfce  guifg=NONE gui=none
highlight diffLine    term=bold ctermbg=magenta ctermfg=white  cterm=bold guibg=#ebdfce  guifg=NONE gui=none

highlight DiffText term=bold ctermbg=black   ctermfg=yellow cterm=bold guibg=#ebdfce  guifg=NONE gui=none
#
highlight PopupScrollbar term=bold ctermfg=4 guifg=#A7A7A7 guibg=NONE

# # for Plug 'RRethy/vim-illuminate'
# highlight illuminatedWord guibg=#191C41

#  indexed search popup
highlight IndexedSearchPopup cterm=bold ctermbg=none ctermfg=magenta gui=bold guibg=#FDBED4 guifg=NONE
