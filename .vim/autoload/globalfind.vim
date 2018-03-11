" find word under cursor
" returns ":Ack! -S -w 'word' src/"
let s:vimrc_superglobalFind = 1
function! globalfind#GlobalFind(isVisualMode, wordMatch, reactRender)
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

    " следующий if - ничего функционального не несет, только делает
    " поменьше дергов когда всего одно окно (помимо NERDTree)
    if (winnr('$') > 2)
        :NERDTreeClose | NERDTree | wincmd l | wincmd j
    endif

    let g:ack_qhandler = saved_ack_qhandler
endfunction

function! globalfind#ToggleGlobalFind()
    if (s:vimrc_superglobalFind)
        let s:vimrc_superglobalFind = 0
        echo "superglobalFind = 0"
    else
        let s:vimrc_superglobalFind = 1
        echo "superglobalFind = 1"
    endif
endfunction
