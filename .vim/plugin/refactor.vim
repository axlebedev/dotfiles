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

const winWidth = 100
const separator = '·'
var maxLen = 0
def GetLine(i: number, key: string): string
    var command = refactorCommands[key].command
    return key .. repeat(' ', maxLen - key->len()) .. ' ' .. separator .. repeat(' ', winWidth - maxLen - command->len()) .. command
enddef
def GetCommandsView(): list<string> 
    maxLen = max(refactorCommands->keys()->map((i, v) => v->len()))
    return refactorCommands->keys()->map(GetLine)
enddef

def RunRefactorCommand(line: string): void
    var key = (line->split(separator))[0]->trim()
    execute refactorCommands[key].command
enddef

command! RefactorCommands fzf#run(fzf#wrap({ source: GetCommandsView(), sink: RunRefactorCommand }))
nnoremap <silent> <Plug>(refactor-commands) <ScriptCmd>RefactorCommands<CR>
