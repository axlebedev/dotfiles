vim9script

export def RequireToImport()
    silent! g/const .\+ = require/normal! 0ciwimport
    silent! g/const \_.\+ = require/normal! 0ciwimport

    # e
    :%s/= require('\(.\+\)')/from '\1'/ge

    :%s/module.exports =/export default/ge
enddef

export def ImportToRequire()
    :%s/import/const/ge

    :%s/from '\(.\+\)'/= require('\1')/ge

    :%s/export default/module.exports =/ge
enddef
