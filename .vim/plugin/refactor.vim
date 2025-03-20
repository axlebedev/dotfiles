vim9script

def Unmerged(): void
    call fzf#vim#files('', {
                \    'source': 'git diff --name-only --diff-filter=U',
                \    'sink': 'e',
                \    'options': '--prompt="Unmerged> "'
                \ })
enddef

var refactorCommands = {
    unmerged: 'call Unmerged()', 
    showIncomingCalls: 'call CocAction("showIncomingCalls")',
    showOutgoingCalls: 'call CocAction("showOutgoingCalls")',
    showOutline: 'call CocAction("showOutline")',
    showSuperTypes: 'call CocAction("showSuperTypes")',
    showSubTypes: 'call CocAction("showSubTypes")',
    rename: 'call CocAction("rename")',
    refactor: 'call CocAction("refactor")',
    codeLens: 'call CocAction("codeLensAction")',
    ALEFix: 'ALEFix',
    ALEFileRename: ':ALEFileRename',
    foldUnchanged: 'call CocCommand git.foldUnchanged',
    referencesUsed: "normal \<Plug>(coc-references-used)",
    findAllFileReferences: 'CocCommand tsserver.findAllFileReferences',
    goToSourceDefinition: 'CocCommand tsserver.goToSourceDefinition',
    executeAutofix: 'CocCommand tsserver.executeAutofix',
    executeEslintAutofix: 'CocCommand eslint.executeAutofix',
}
def RunRefactorCommand(key: string): void
    execute refactorCommands[key]
enddef

command! RefactorCommands fzf#run(fzf#wrap({ source: refactorCommands->keys(), sink: RunRefactorCommand }))
nnoremap <silent> <Plug>(refactor-commands) <ScriptCmd>fzf#run(fzf#wrap({ source: refactorCommands->keys(), sink: RunRefactorCommand }))<CR>
