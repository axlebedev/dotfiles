-- Split right + previous buffer (native)
vim.api.nvim_create_user_command(
  'S',
  'vs | wincmd h | bprev | wincmd l',
  {}
)
