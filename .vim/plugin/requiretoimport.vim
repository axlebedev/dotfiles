vim9script

def RequireToImport()
    silent! g/const .\+ = require/normal! 0ciwimport
    silent! g/const \_.\+ = require/normal! 0ciwimport

    :%s/= require('\(.\+\)')/from '\1'/ge

    :%s/module.exports =/export default/ge
enddef

def ImportToRequire()
    :%s/import/const/ge

    :%s/from '\(.\+\)'/= require('\1')/ge

    :%s/export default/module.exports =/ge
enddef

command! RequireToImport RequireToImport()
command! ImportToRequire ImportToRequire()

nnoremap rti <ScriptCmd>requiretoimport.RequireToImport()<CR>
nnoremap itr <ScriptCmd>requiretoimport.ImportToRequire()<CR>
