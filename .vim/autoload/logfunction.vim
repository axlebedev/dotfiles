vim9script

import 'vim-js-fastlog.vim' as jsLog

export def LogFunction()
    normal! yiw
    normal! beaLAL
    normal! oexport const = (...args) => {}
    execute "normal! 0eeli "
    normal! p$
    execute "normal! i\n"
    normal! k0ww
    normal! yiw
    normal! jo
    normal! pviw
    jsLog.JsFastLog_string_trace('v')
    normal! a, ...args
    normal! jj
    execute 'normal! oreturn '
    normal! paLAL(...args);
enddef
