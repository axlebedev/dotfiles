vim.opt.synmaxcol = 1000

vim.opt.colorcolumn = "100"

vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.background = 'light'
vim.cmd('colorscheme PaperColor')  -- Install via Lazy first

vim.opt.termguicolors = true
vim.opt.cursorline = true

vim.opt.fillchars = { vert = "│", eob = "░" }

vim.opt.list = true
vim.opt.listchars = "tab:· ,trail:•,extends:»,precedes:«,conceal:_,nbsp:•"

vim.opt.showbreak = "»"

-- vim-illuminate settings (identical)
vim.g.Illuminate_delay = 100
vim.g.Illuminate_ftblacklist = { 'nerdtree', 'magit' }
vim.g.Illuminate_ftHighlightGroups = {
  javascript = {
    blacklist = {
      'Statement', 'Noise', 'PreProc', 'Type', 
      'jsStorageClass', 'jsImport', 'Include'
    }
  }
}
