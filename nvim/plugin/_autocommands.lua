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

local vimagit_group = vim.api.nvim_create_augroup('autoupdate_on_vimagit', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = vimagit_group,
  pattern = 'VimagitUpdateFile',
  command = 'checktime'
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
  -- callback = function() vim.cmd('echo "LALALA"') end
})

-- Window resize
vim.api.nvim_create_autocmd('VimResized', {
  group = vimrc_group,
  command = 'wincmd ='
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
