function! s:sortAttribute() abort
    call cursor(1, 1)
    let lastSearch = 0
    while 1
        " go to next <tag definition, not <!--
        call search('<[a-zA-Z]\+ ', 'W')

        " split attributes by lines
        execute 'silent! s/\S\+="[^"]*"/\r\0\r/g'

        " return to tag start
        call search('<[a-zA-Z]\+ ', 'bW')

        " sort attributes
        execute 'silent! .+1,/>/-1sort'
        " if nothing found in rest of buffer - break
        if search('<[a-zA-Z]\+ ', 'n') <= lastSearch
            break
        endif
        let lastSearch = search('<[a-zA-Z]\+ ', 'nW')
    endwhile
endfunction

function! s:sortClasses() abort
    call cursor(1, 1)
    while search('class=', 'nW') != 0
        call search('class=', 'W')
        execute 'silent! s/"/"\r'
        execute 'silent! s/ /\r/g'
        call search('"', 'W')
        execute 'silent! s/"/\r"'
        call search('"', 'bW')
        execute 'silent! .+1,/"/-1sort'
    endwhile
endfunction

function! s:sortStyles() abort
    call cursor(1, 1)
    while search('style=', 'nW') != 0
        call search('style=', 'W')
        execute 'silent! s/: */: '
        execute 'silent! s/"/"\r'
        execute 'silent! s/;/;\r/g'
        execute 'silent! s/"/\r"'
        call search('"', 'bW')
        execute 'silent! .+1,/"/-1sort'
    endwhile
endfunction

function! htmlbeautify#htmlbeautify() abort
    execute 'set ft=html'

    " remove comments
    execute 'silent! %s/<!--\_.\{-}-->//g'

    " split tags by lines
    execute 'silent! %s/<[^>]*>/\r&\r/g'

    " enter temporary first line to make search work well
    normal! ggOstart

    " split attributes by lines
    call s:sortAttribute()

    " split classes by lines
    call s:sortClasses()

    " split styles by lines
    call s:sortStyles()

    " remove blank lines
    execute 'g/^\s*$/d'

    " indent all and remove temporary first line
    normal! ggdd=Ggg
endfunction
