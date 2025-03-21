vim9script

def Unmerged(): void
    call fzf#vim#files('', {
                \    'source': 'git diff --name-only --diff-filter=U',
                \    'sink': 'e',
                \    'options': '--prompt="Unmerged> "'
                \ })
enddef

def RenameSymbol()
    var word = expand('<cword>')
    var newname = input('New name: ', word)
    if (!empty(newname))
        execute "call CocAction('rename', '" .. newname .. "')"
    endif
enddef

var refactorCommands = {
    'Unmerged': {
        command: 'call Unmerged()',
    },
    'Show incoming calls': {
        command: 'call CocAction("showIncomingCalls")',
    },
    'Show outgoing calls': {
        command: 'call CocAction("showOutgoingCalls")',
    },
    'Show outline': {
        command: 'call CocAction("showOutline")',
    },
    'Show super types': {
        command: 'call CocAction("showSuperTypes")',
    },
    'Show subTypes': {
        command: 'call CocAction("showSubTypes")',
    },
    'Rename': {
        command: 'call RenameSymbol()',
    },
    'Refactor': {
        command: 'call CocAction("refactor")',
    },
    'Code lens': {
        command: 'call CocAction("codeLensAction")',
    },
    'ALE fix': {
        command: 'ALEFix',
    },
    'ALE file rename': {
        command: ':ALEFileRename',
    },
    'Fold unchanged': {
        command: 'call CocCommand git.foldUnchanged',
    },
    'References used': {
        command: "normal \<Plug>(coc-references-used)",
    },
    'Find all file references': {
        command: 'CocCommand tsserver.findAllFileReferences',
    },
    'Go to source definition': {
        command: 'CocCommand tsserver.goToSourceDefinition',
    },
    'Execute autofix': {
        command: 'CocCommand tsserver.executeAutofix',
    },
    'Execute eslint autofix': {
        command: 'CocCommand eslint.executeAutofix',
    },
}

def GetCommandsView(): list<string> 
    return refactorCommands->keys()->map((key, val) => val .. '  |  ' .. refactorCommands[val].command)
enddef

def RunRefactorCommand(key: string): void
    execute refactorCommands.command
enddef

command! RefactorCommands fzf#run(fzf#wrap({ source: GetCommandsView(), sink: RunRefactorCommand }))
nnoremap <silent> <Plug>(refactor-commands) <ScriptCmd>RefactorCommands<CR>
