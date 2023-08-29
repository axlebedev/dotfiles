vim9script

var startTagRegexp = '<[a-zA-Z0-9]\+ '
def SortAttribute()
    cursor(1, 1)
    while (search(startTagRegexp, 'nW') != 0)
        # go to next <tag definition, not <!--
        search(startTagRegexp, 'W')

        # split attributes by lines
        execute 'silent! s/\S\+="[^"]*"/\r\0\r/g'

        # return to tag start
        search(startTagRegexp, 'bW')

        # sort attributes
        execute 'silent! .+1,/>/-1sort'
        # if nothing found in rest of buffer - break
    endwhile
enddef

def SortClasses()
    cursor(1, 1)
    while (search('class=', 'nW') != 0)
        search('class=', 'W')
        execute 'silent! s/"/"\r'
        execute 'silent! s/ /\r/g'
        search('"', 'W')
        execute 'silent! s/"/\r"'
        search('"', 'bW')
        execute 'silent! .+1,/"/-1sort'
    endwhile
enddef

def SortStyles()
    cursor(1, 1)
    while (search('style=', 'nW') != 0)
        search('style=', 'W')
        execute 'silent! s/: */: '
        execute 'silent! s/"/"\r'
        execute 'silent! s/;/;\r/g'
        execute 'silent! s/"/\r"'
        search('"', 'bW')
        execute 'silent! .+1,/"/-1sort'
    endwhile
enddef

export def Htmlbeautify()
    execute 'set ft=html'

    # remove comments
    execute 'silent! %s/<!--\_.\{-}-->//g'

    # split tags by lines
    execute 'silent! %s/<[^>]*>/\r&\r/g'

    # enter temporary first line to make search work well
    normal! ggOstart

    # split attributes by lines
    SortAttribute()

    # split classes by lines
    SortClasses()

    # split styles by lines
    SortStyles()

    # remove blank lines
    execute 'g/^\s*$/d'

    # indent all and remove temporary first line
    normal! ggdd=Ggg
enddef
