-- Clear all autocmds in group (Neovim equivalent)
local vimrc_group = vim.api.nvim_create_augroup('au_vimrc', { clear = true })

-- Match HTML tags (native)
vim.cmd.runtime('macros/matchit.vim')

-- Restore last position (native, improved)
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vimrc_group,
  callback = function()
    local markpos = vim.api.nvim_buf_get_mark(0, '"')
    if markpos[1] > 0 and markpos[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, markpos)
    end
  end,
})

-- TODO
-- Close empty buffer (REQUIRES kwbd.vim plugin)
-- vim.api.nvim_create_autocmd('BufLeave', {
--   group = vimrc_group,
--   callback = function()
--     if vim.api.nvim_buf_line_count(0) == 1
--        and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == ''
--        and vim.fn.expand('%:t') == ''
--        and vim.bo.filetype ~= 'qf' then
--       vim.cmd('Kwbd 1')
--     end
--   end,
-- })

-- TODO: make it work
-- winview plugin autocmds (REQUIRES winview.vim)
-- vim.api.nvim_create_autocmd('BufLeave', { command = 'AutoSaveWinView' })
-- vim.api.nvim_create_autocmd('BufEnter', { command = 'AutoRestoreWinView' })

-- Filetype fixes (native)
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.qf',
  command = 'setf qf'
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.styl',
  command = 'setf css'
})
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = '*',
  callback = function()
    -- delete trailing ws
    local cursor_pos = vim.fn.getpos(".")
    vim.api.nvim_exec2([[%s/\s\+$//e]], { output = false })
    vim.fn.setpos('.', cursor_pos)
  end,
})

-- Fugitive foldmethod fix (simplified)
local fold_group = vim.api.nvim_create_augroup('au_vimrc_foldmethod', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = fold_group,
  callback = function()
    if vim.fn.bufname('%'):match('fugitive') then
      vim.opt_local.foldmethod = 'manual'
    end
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = vimrc_group,
  callback = function()
    vim.fn.timer_start(100, function() vim.cmd('FindCursor #d6d8fa 1000') end)
  end
})

-- Diff folding (native)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'diff' },
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = "getline(v:lnum)=~'^diff\\s'?'>1':1"
    vim.opt_local.foldtext = "getline(v:foldstart)"
  end,
})

-- close nvim if only nvim-tree window
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd("quit")
    end
  end
})

-- auto set filetype (especially json, yaml, lua, python)
vim.api.nvim_create_autocmd({ "BufRead", "TextChanged", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("PasteFiletypeDetect", { clear = true }),
  callback = function()
    -- Only run if the buffer has no name and no filetype set
    if vim.bo.filetype == "" then
      vim.print(100)

      -- Grab current buffer contents
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      -- Skip empty buffers
      if #lines == 0 or (#lines == 1 and lines[1] == "") then
        return
      end

      local ft = vim.filetype.match({ buf = 0, contents = lines})

      if not ft then
        local first = lines[1] or ""

        -- JSON: starts with { or [ and is valid JSON
        if first:match("^%s*[%[{]") then
          local ok, _ = pcall(vim.json.decode, table.concat(lines, "\n"))
          if ok then ft = "json" end
        end

        -- YAML: starts with --- or has key: value patterns
        if not ft and (first:match("^%-%-%-") or first:match("^%s*%w[%w_]*%s*:")) then
          ft = "yaml"
        end

        -- Lua: common patterns
        if not ft and (first:match("^%s*local%s") or first:match("^%s*function%s") or first:match("^%s*return%s")) then
          ft = "lua"
        end

        -- Python: shebang or common imports
        if not ft and (first:match("^#!/.*python") or first:match("^%s*import%s") or first:match("^%s*from%s.*import")) then
          ft = "python"
        end
      end

      if ft then
        vim.bo.filetype = ft
      end
    end
  end,
})
