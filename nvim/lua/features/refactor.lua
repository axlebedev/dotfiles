local custom_menu = require('features/custom_menu').custom_menu

local M = {}

--     # 'COC: codeaction': { #     command: 'call CocActionAsync("codeAction", "")',
  --
--     'COC: format-selected': { command: 'call CocActionAsync("formatSelected", visualmode())',
--     'COC: codeaction-source': { command: 'call CocActionAsync("codeAction", "", ["source"], v:true)',
--     'COC: codeaction-line': { command: 'call CocActionAsync("codeAction", "currline")',
--     'COC: codeaction-cursor': { command: 'call CocActionAsync("codeAction", "cursor")',
--     'COC: doQuickfix': { command: 'call CocActionAsync("doQuickfix")',
  --
--     'GIT: Unmerged': { command: 'call Unmerged()', # map <c-g><c-u>
  --
  --
--     'COC: Show super types': { command: 'call CocActionAsync("showSuperTypes")',
--     'COC: Show subTypes': { command: 'call CocActionAsync("showSubTypes")',
  --
--     'COC: Rename file (ts)': { command: 'CocCommand tsserver.renameFile',
--     # 'COC: Refactor': { #     command: 'call CocActionAsync("refactor")',
--     # 'COC: codeLensAction': { #     command: 'call CocActionAsync("codeLensAction")',
--     'GIT: Fold unchanged': { command: 'CocCommand git.foldUnchanged',
--     'COC: References used': { command: "call CocActionAsync('jumpUsed')",
--     'COC: Go to source definition (ts)': { command: 'CocCommand tsserver.goToSourceDefinition',
--     # 'EslintAutofix': { #     command: 'call EslintAutofix()',
--     # 'TsserverAutofix()': { #     command: 'call TsserverAutofix()',
--     'EslintChangedFix()': { command: 'call EslintChangedFix()',
--     'COC: file references (ts)': { command: 'CocCommand tsserver.findAllFileReferences',
--     'EslintChangedFiles': { command: 'call LintChangedFiles()',

local opts = {
  {
    name = 'Remove unused code',
    lspAction = "source.removeUnused.ts",
  },
  {
    name = 'Add missing imports',
    lspAction = "source.addMissingImports.ts",
  },
  {
    name = 'Remove unused imports',
    lspAction = "source.removeUnusedImports",
  },
  {
    name = 'Fix all',
    lspAction = 'source.fixAll',
  },
  {
    name = 'Show incoming calls',
    callback = vim.lsp.buf.incoming_calls
  },
  {
    name = 'Outline',
    command = 'Outline'
  },
  {
    name = 'Rename',
    callback = vim.lsp.buf.rename
  },
    -- 'COC: Show super types': {
    --     command: 'call CocActionAsync("showSuperTypes")',
    -- },
    --
  {
    name = 'Find file refs',
    lspAction = 'vtsls.fileReferences',
  },
  {
    name = 'refactor.rewrite.arrow.braces',
    lspAction = 'refactor.rewrite.arrow.braces',
  }
}

-- Map it to a key
vim.keymap.set('n', '<leader>r', function() custom_menu(opts) end, { desc = 'Custom Menu' })

return M
