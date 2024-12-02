vim9script

# quickfix next
def Cn()
    Cnext
    # it should run after buffer change
    timer_start(1, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
nnoremap <silent> cn <ScriptCmd>Cn()<CR>
# quickfix prev
def Cp()
    Cprev
    # it should run after buffer change
    timer_start(1, (id) => findcursor#FindCursor('#d6d8fa', 0))
enddef
nnoremap <silent> cp <ScriptCmd>Cp()<CR>
