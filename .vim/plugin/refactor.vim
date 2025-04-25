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

var EslintChangedFix = longcommandwithpopup.CreateLongRunningFunctionSystem('yarn lint:fix', 'yarn lint:fix', () => updatebuffer.UpdateBuffer(1))

def TsserverAutofixInner()
    CocCommand tsserver.executeAutofix
    :%s/from 'packages/from '@nct/ge
    silent read !npx eslint --fix % > /dev/null 2>1
enddef
var TsserverAutofix = longcommandwithpopup.CreateLongRunningFunctionVim(
    TsserverAutofixInner,
    'Tsserver Autofix'
)

var refactorCommands = {
    'COC: format-selected': {
        command: 'call CocActionAsync("formatSelected", visualmode())',
    },
    # Nos only 'move to file' and 'move to a new file'
    # 'COC: codeaction': {
    #     command: 'call CocActionAsync("codeAction", "")',
    # },
    'COC: codeaction-source': {
        command: 'call CocActionAsync("codeAction", "", ["source"], v:true)',
        hint: 'Remove unused, fix imports',
    },
    'COC: codeaction-line': {
        command: 'call CocActionAsync("codeAction", "currline")',
        hint: 'Extract to function',
    },
    'COC: codeaction-cursor': {
        command: 'call CocActionAsync("codeAction", "cursor")',
        hint: 'Inline variable',
    },
    'COC: doQuickfix': {
        command: 'call CocActionAsync("doQuickfix")',
    },
    'GIT: Unmerged': {
        command: 'call Unmerged()',
        hint: 'List Unmerged files',
    },
    'COC: Show incoming calls': {
        command: 'call CocActionAsync("showIncomingCalls")',
    },
    'COC: Show outgoing calls': {
        command: 'call CocActionAsync("showOutgoingCalls")',
    },
    'COC: Show outline': {
        command: 'call CocActionAsync("showOutline")',
    },
    'COC: Show super types': {
        command: 'call CocActionAsync("showSuperTypes")',
    },
    'COC: Show subTypes': {
        command: 'call CocActionAsync("showSubTypes")',
    },
    'COC: Rename': {
        command: 'call CocActionAsync("rename")',
    },
    'COC: Rename file (ts)': {
        command: 'CocCommand tsserver.renameFile',
    },
    # 25.04.2025 Throws error. Check it later
    # 'COC: Refactor': {
    #     command: 'call CocActionAsync("refactor")',
    # },
    # Deepseek can tell what is this used for. Maybe show coverage?
    # 'COC: codeLensAction': {
    #     command: 'call CocActionAsync("codeLensAction")',
    # },
    'GIT: Fold unchanged': {
        command: 'CocCommand git.foldUnchanged',
    },
    'COC: References used': {
        command: "call CocActionAsync('jumpUsed')",
    },
    'COC: Go to source definition (ts)': {
        command: 'CocCommand tsserver.goToSourceDefinition',
    },
    'TsserverAutofix()': {
        command: 'call TsserverAutofix()',
    },
    'EslintChangedFix()': {
        command: 'call EslintChangedFix()',
    },
    'COC: file references (ts)': {
        command: 'CocCommand tsserver.findAllFileReferences',
    }
}


const winWidth = 100
const separator = '·'

def Colored(word: string, color: dict<number>): string # color: { r: number, g: number, b: number }
  # [48;2 for background
  return "\e[38;2;" .. color.r .. ';' .. color.g .. ';' .. color.b .. 'm' .. word .. "\e[0m"
enddef

def GetLine(i: number, key: string): string
  var colorKey = Colored(key, { r: 62, g: 50, b: 168 }) 
  var rightPart = refactorCommands[key]->has_key('hint')
    ? Colored(refactorCommands[key].hint, { r: 255, g: 100, b: 0 }) 
    : Colored(refactorCommands[key].command, { r: 255, g: 150, b: 90 }) 
  return colorKey .. ' ' .. separator .. ' ' .. rightPart
enddef

def GetCommandsView(): list<string> 
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
vnoremap <silent> <Plug>(refactor-commands) <ScriptCmd>RefactorCommands<CR>
