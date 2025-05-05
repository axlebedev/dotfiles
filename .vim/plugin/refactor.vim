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

var EslintChangedFix = longcommandwithpopup.CreateLongRunningFunctionSystem(
    'yarn lint:fix',
    'yarn lint:fix',
    () => updatebuffer.UpdateBuffer(1),
)

var TsserverAutofix = longcommandwithpopup.CreateLongRunningFunctionVim(
    () => {
        CocCommand tsserver.executeAutofix
        :%s/from 'packages/from '@nct/ge
        silent read !npx eslint --fix % > /dev/null 2>1
    },
    'Tsserver Autofix'
)

var EslintFixCurrent = longcommandwithpopup.CreateLongRunningFunctionSystem('npx eslint --fix ' .. expand("%:."), 'npx eslint --fix %', () => updatebuffer.UpdateBuffer(1))

var LintChangedFiles = longcommandwithpopup.CreateLongRunningFunctionVim(
    () => {
        var files = systemlist('git diff --diff-filter=ACM --name-only $(git merge-base HEAD origin/master) -- "*.js" "*.jsx" "*.ts" "*.tsx"')
        if (empty(files)) | return | endif

        # Run eslint directly and parse output to quickfix
        var cmd = 'npx eslint --cache --no-error-on-unmatched-pattern --format=compact ' .. join(files, ' ')
        var output = system(cmd)

        var qflist = []
        var regex = '\v(Error|Warning)'

        for line in split(output, "\n")
            if line =~# regex
                var parts = split(line, ':')
                var filename = parts[0]
                var other = parts[1 : ]->join('')

                var linenr = matchlist(other, '\vline (\d+)')[1]
                var colnr = matchlist(other, '\vcol (\d+)')[1]
                var text = matchlist(other, '\vcol \d+, (.*)')[1]

                qflist->add({
                    filename: filename,
                    lnum: linenr->str2nr(),
                    col: colnr->str2nr(),
                    text: text->trim(),
                    type: line =~# ' error:' ? 'E' : 'W' })
            endif
        endfor

        echo qflist
        setqflist([], ' ', { items: qflist, title: 'ESLint Errors' })
        if (!empty(qflist)) | copen | endif
    },
    'LintChangedFiles'
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
    },
    '!npx eslint --fix %': {
        command: 'call EslintFixCurrent()',
    },
    'LintChangedFiles': {
        command: 'call LintChangedFiles()',
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
