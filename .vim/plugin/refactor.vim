vim9script

import autoload '../autoload/updatebuffer.vim'
import autoload '../autoload/longcommandwithpopup.vim'

def Unmerged(): void
    call fzf#vim#files('', {
                \    'source': 'git diff --name-only --diff-filter=U',
                \    'sink': 'e',
                \    'options': '--prompt="Unmerged> "'
                \ })
enddef

var EslintChanged = longcommandwithpopup.CreateLongRunningFunctionSystem('yarn lint:fix', 'Eslint', () => updatebuffer.UpdateBuffer(1))

def TsserverAutofixInner()
    legacy call CocAction('runCommand', 'tsserver.executeAutofix')
    :%s/from 'packages/from '@nct/ge
    silent read !npx eslint --fix % > /dev/null 2>1
enddef
var TsserverAutofix = longcommandwithpopup.CreateLongRunningFunctionVim(
    TsserverAutofixInner,
    'Tsserver Autofix'
)

var refactorCommands = {
    'coc-format-selected': {
        command: 'call CocActionAsync("formatSelected", visualmode())',
    },
    'coc-codeaction': {
        command: 'call CocActionAsync("codeAction", "")',
    },
    'coc-codeaction-source': {
        command: 'call CocActionAsync("codeAction", "", ["source"], v:true)',
    },
    'coc-codeaction-line': {
        command: 'call CocActionAsync("codeAction", "currline")',
    },
    'coc-codeaction-cursor': {
        command: 'call CocActionAsync("codeAction", "cursor")',
    },
    'coc-fix-current': {
        command: 'call CocActionAsync("doQuickfix")',
    },
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
        command: 'call CocActionAsync("rename")',
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
    'Execute TsserverAutofix': {
        command: 'call TsserverAutofix()',
    },
    'Execute EslintChanged': {
        command: 'call EslintChanged()',
    },
}

const winWidth = 100
const separator = '·'
var maxLen = 0

def Colored(word: string, color: dict<number>): string # color: { r: number, g: number, b: number }
  # [48;2 for background
  return "\e[38;2;" .. color.r .. ';' .. color.g .. ';' .. color.b .. 'm' .. word .. "\e[0m"
enddef

def GetLine(i: number, key: string): string
  var colorKey = Colored(key, { r: 62, g: 50, b: 168 }) 
  var spacer1 = repeat(' ', maxLen - key->len()) # between left part and separator
  var command = Colored(refactorCommands[key].command, { r: 255, g: 100, b: 0 }) 
  var spacer2 = repeat(' ', winWidth - maxLen - command->len()) # between separator and right part
  return colorKey .. spacer1 .. ' ' .. separator .. spacer2 .. command
enddef

def GetCommandsView(): list<string> 
    maxLen = max(refactorCommands->keys()->map((i, v) => v->len()))
    return refactorCommands->keys()->map(GetLine)
enddef

def RunRefactorCommand(line: string): void
    var key = (line->split(separator))[0]->trim()
    execute refactorCommands[key].command
enddef

command! RefactorCommands fzf#run(fzf#wrap({
      \   source: GetCommandsView(), 
      \   sink: RunRefactorCommand, 
      \   options: '--ansi',
      \ }))
nnoremap <silent> <Plug>(refactor-commands) <ScriptCmd>RefactorCommands<CR>
