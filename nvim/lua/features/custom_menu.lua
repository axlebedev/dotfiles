local M = {}

M.custom_menu = function(opts)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

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

return M
