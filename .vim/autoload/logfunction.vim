vim9script

import 'vim-js-fastlog.vim' as jsLog

export def LogFunction()
    normal! yiweaLAL
    normal! oexport const = (...args) => {}
    execute "normal! 0eeli "
    normal! p$
    execute "normal! i\n"
    normal! k0wwviw
    jsLog.JsFastLog_function('')
    normal! a, ...args
    execute 'normal! oreturn '
    normal! paLAL(...args);
enddef
