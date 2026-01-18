-- Scroll/cursor bind both windows (native)
vim.api.nvim_create_user_command('BindBoth', function()
  vim.opt.scrollbind = true
  vim.opt.cursorbind = true
  vim.cmd('wincmd p')
  vim.opt.scrollbind = true
  vim.opt.cursorbind = true
  vim.cmd('wincmd p')
end, {})

vim.api.nvim_create_user_command('BindBothOff', function()
  vim.opt.noscrollbind = true
  vim.opt.nocursorbind = true
  vim.cmd('wincmd p')
  vim.opt.noscrollbind = true
  vim.opt.nocursorbind = true
  vim.cmd('wincmd p')
end, {})

-- Split right + previous buffer (native)
vim.api.nvim_create_user_command('S', function()
  vim.cmd('vs')
  vim.cmd('wincmd h')
  vim.cmd('bprev')
  vim.cmd('wincmd l')
end, {})

-- New terminal instance (Linux - replace with your terminal)
vim.api.nvim_create_user_command('NewInstance', 
  '!kitty -- vim % > /dev/null 2>&1', 
  { desc = 'New terminal vim instance' })

-- Quickfix wrap (native)
vim.api.nvim_create_user_command('Cnext', 
  'try | cnext | catch | cfirst | catch | endtry', 
  {})

vim.api.nvim_create_user_command('Cprev', 
  'try | cprev | catch | clast | catch | endtry', 
  {})

vim.api.nvim_create_user_command('Lnext', 
  'try | lnext | catch | lfirst | catch | endtry', 
  {})

vim.api.nvim_create_user_command('Lprev', 
  'try | lprev | catch | llast | catch | endtry', 
  {})

vim.api.nvim_create_user_command('DemoOn', function()
  -- Empty - plugins don't exist in your Neovim stack
  print("Demo mode: ALE/FindCursor disabled (not installed)")
end, {})

vim.api.nvim_create_user_command('DemoOff', function()
  print("Demo mode off")
end, {})

-- New window vim instance (Linux)
vim.api.nvim_create_user_command('WinNew', function()
  local fname = vim.fn.expand('%')
  vim.system({ 'kitty', '--', 'vim', fname }, { text = true }):wait()
  vim.cmd('redraw!')
end, {})

-- TODO: commands for footprints/findcursor
