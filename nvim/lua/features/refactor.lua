local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

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
    callback = vim.lsp.buf.rename,
  },
    -- 'COC: Show super types': {
    --     command: 'call CocActionAsync("showSuperTypes")',
    -- },
    --
    -- 'COC: Rename file (ts)': {
    --     command: 'CocCommand tsserver.renameFile',
    -- },
  {
    name = 'refactor.rewrite.arrow.braces',
    lspAction = 'refactor.rewrite.arrow.braces',
  }
}

local custom_menu = function()
  pickers.new(opts, {
    prompt_title = "My Custom Menu",
    finder = finders.new_table({
      results = opts,
      entry_maker = function(optsEntry)
        return {
          value = optsEntry,
          display = optsEntry.name, -- Display name
          -- TelescopeResultTitle Field Class
          ordinal = optsEntry.name, -- Text for searching
          callback = optsEntry.callback,
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection.value.lspAction ~= nil then
          vim.lsp.buf.code_action({
              context = { only = { selection.value.lspAction }, diagnostics = {} },
              apply = true,
            })
        end
        if selection.value.callback ~= nil then
          selection.value.callback()
        end
        if selection.value.command ~= nil then
          vim.cmd(selection.value.command)
        end
      end)
      return true
    end,
  }):find()
end

-- Map it to a key
vim.keymap.set('n', '<leader>1', custom_menu, { desc = 'Custom Menu' })

return M
