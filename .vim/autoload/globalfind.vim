" find word under cursor
" returns ":Ack! -S -w 'word' src/"
let s:vimrc_superglobalFind = 0
let s:vimrc_findInTest = 0

function! s:FilterTestEntries(qflist) abort
    return filter(a:qflist, "bufname(v:val.bufnr) !~# '__test__'")
endfunction

function! globalfind#GlobalFind(isVisualMode, wordMatch, reactRender) abort
    let saved_ack_qhandler = g:ack_qhandler
    let word = ""
    if (a:isVisualMode)
        let word = l9#getSelectedText()
    else
        let word = expand("<cword>")
    endif

    let promptString = 'Searching text: '
    if (a:wordMatch)
        let promptString = 'Searching word: '
    elseif (a:reactRender)
        let promptString = 'Searching where render: '
    endif

    let searchingWord = input(promptString, word)

    if (empty(searchingWord))
        return
    endif

    let @/ = searchingWord
    set hlsearch
    let g:ack_qhandler = winnr('$') > 2 ? 'botright copen' : 'belowright copen'

    let searchingWord = substitute(searchingWord, '(', '\\(', '')
    let searchingWord = substitute(searchingWord, ')', '\\)', '')

    let searchCommand = ":Ack! -S "
    let path = s:vimrc_superglobalFind ? "." : "src/"

    if (a:wordMatch)
        :execute searchCommand."-w '".searchingWord."' ".path
    elseif (a:reactRender)
        :execute searchCommand."'<".searchingWord."\\b' ".path
    else
        :execute searchCommand."'".searchingWord."' ".path
    endif

    if (s:vimrc_findInTest == 0)
        call setqflist(s:FilterTestEntries(getqflist()))
    endif

    " следующий if - ничего функционального не несет, только делает
    " поменьше дергов когда всего одно окно (помимо NERDTree)
    if (winnr('$') > 2)
        :NERDTreeClose | NERDTree | wincmd l | wincmd j
    endif

    let g:ack_qhandler = saved_ack_qhandler
endfunction

function! globalfind#ToggleGlobalFind() abort
    if (s:vimrc_superglobalFind)
        let s:vimrc_superglobalFind = 0
        echo "superglobalFind = 0"
    else
        let s:vimrc_superglobalFind = 1
        echo "superglobalFind = 1"
    endif
endfunction

function! globalfind#ToggleTestSearch() abort
    if (s:vimrc_findInTest)
        let s:vimrc_findInTest = 0
        echo "vimrc_findInTest = 0"
    else
        let s:vimrc_findInTest = 1
        echo "vimrc_findInTest = 1"
    endif
endfunction
