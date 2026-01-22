vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript' },
  callback = function() vim.treesitter.start() end,
})
