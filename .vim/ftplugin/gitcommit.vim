vim9script

setlocal foldmethod=expr
setlocal foldexpr=getline(v:lnum)=~'^diff\\s'?'>1':1
