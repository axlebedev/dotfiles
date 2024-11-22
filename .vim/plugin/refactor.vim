vim9script

var refactorCommands = {
    showIncomingCalls: 'call CocAction("showIncomingCalls")',
    showOutgoingCalls: 'call CocAction("showOutgoingCalls")',
    showOutline: 'call CocAction("showOutline")',
    showSuperTypes: 'call CocAction("showSuperTypes")',
    showSubTypes: 'call CocAction("showSubTypes")',
    refactor: 'call CocAction("refactor")',
}
def RunRefactorCommand(key: string): void
    execute refactorCommands[key]
enddef

command! RefactorCommands fzf#run(fzf#wrap({ source: refactorCommands->keys(), sink: RunRefactorCommand }))
nnoremap <silent> <Plug>(refactor-commands) <ScriptCmd>fzf#run(fzf#wrap({ source: refactorCommands->keys(), sink: RunRefactorCommand }))<CR>
