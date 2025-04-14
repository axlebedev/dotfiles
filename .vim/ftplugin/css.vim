vim9script

import autoload '../autoload/variables.vim'

execute 'setlocal tabstop=' .. variables.indent
execute 'setlocal softtabstop=' .. variables.indent
execute 'setlocal shiftwidth=' .. variables.indent

setlocal iskeyword+=-
