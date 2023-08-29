vim9script

# make single-line code to blocked
export def BlockLine()
    cursor(line('.'), 1)
    search('if')
    normal! f(%l"dDA {
    normal! o
    normal! "dp==o}
enddef
