local vimdir = vim.fn.expand("~") .. "/nvim"

-- Создание директорий
local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

ensure_dir(vimdir .. "/tmp/swap")
if vim.fn.has("persistent_undo") == 1 then
  ensure_dir(vimdir .. "/tmp/undo")
end

-- Английский интерфейс (только для GUI)
if vim.fn.has("gui_running") == 1 then
  vim.opt.langmenu = "en_US.UTF-8"
  vim.opt.encoding = "utf-8"
  vim.opt.fileencoding = "utf-8"
end

-- Переменные окружения
vim.env.LANG = "en_US"
vim.env.PAGER = ""

-- Загрузка английских меню (если нужно)
vim.cmd.source("$VIMRUNTIME/delmenu.vim")
vim.cmd.source("$VIMRUNTIME/menu.vim")

-- Основные опции
vim.opt.hidden = true
vim.opt.autoread = true
vim.opt.scrolloff = 5

-- Diff настройки
if vim.opt.diff:get() then
  vim.opt.scrolloff = 5
  vim.opt.sidescrolloff = 15
  vim.opt.sidescroll = 1
  vim.opt.diffopt:append("iwhite")
end

vim.opt.path = { ".", "", "**" }
vim.opt.backspace = "indent,eol,start"
vim.opt.wildmenu = true
vim.opt.wildmode = "list:full"
vim.opt.wildignorecase = true

-- Wildignore (исправлено)
vim.opt.wildignore = {
  "*.sqp", "*.log",
  "*/node_modules/*", "*/bower_components/*", "*/build/*", "*/dist/*",
  "*happypack/*", "*/lib/*", "*/coverage/*"
}

-- Индентинг
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Производительность
vim.opt.timeoutlen = 300
vim.opt.lazyredraw = true
vim.opt.history = 500

-- Swap/backup/undo
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.directory = vimdir .. "/tmp/swap//,.,/var/tmp//,/tmp//"
if vim.fn.has("persistent_undo") == 1 then
  vim.opt.undofile = true
  vim.opt.undodir = vimdir .. "/tmp/undo"
end

-- Поиск
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Сплиты
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Фолдинг
vim.opt.foldenable = true
vim.opt.foldmethod = "syntax"
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.fillchars = {
  eob = ' ',
  fold = ' ',
  foldopen = '-',
  foldsep = ' ',
  foldinner = ' ',
  foldclose = '+',
  vert = ' ',
  eob = "░"
}

-- UI
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.startofline = false
vim.opt.joinspaces = false
vim.opt.errorbells = false
vim.opt.shortmess:remove("S")
vim.opt.title = true

-- Форматирование
vim.opt.formatoptions:append("j")
vim.opt.nrformats:remove("octal")
vim.opt.diffopt:append("internal,algorithm:patience,indent-heuristic")

-- Markdown
vim.g.markdown_folding = 1
vim.g.markdown_fenced_languages = { "javascript", "html", "css" }

-- Clipboard
if vim.fn.has("unnamedplus") == 1 then
  vim.opt.clipboard = "unnamedplus,unnamed"
else
  vim.opt.clipboard:append("unnamed")
end

-- Автогруппа
local au_vimrc_settings = vim.api.nvim_create_augroup("au_vimrc_settings", { clear = true })

-- Автокоманды
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = au_vimrc_settings,
  callback = function()
    vim.opt_local.foldlevel = vim.opt_local.foldlevel:get() > 0 and vim.opt_local.foldlevel:get() or 99
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = au_vimrc_settings,
  pattern = { ".eslintrc", ".babelrc" },
  callback = function()
    vim.bo.filetype = "json"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = au_vimrc_settings,
  pattern = ".conkyrc",
  callback = function()
    vim.bo.filetype = "python"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  group = au_vimrc_settings,
  pattern = "*.md",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = au_vimrc_settings,
  pattern = "vim",
  callback = function()
    vim.opt_local.foldmethod = "marker"
    vim.opt_local.colorcolumn = "80"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = au_vimrc_settings,
  pattern = "qf",
  callback = function()
    vim.opt_local.wrap = false
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = au_vimrc_settings,
  pattern = "gitcommit",
  callback = function()
    vim.api.nvim_win_set_cursor(0, { 1, 1 })
  end,
})

vim.api.nvim_create_autocmd({ "FocusLost" }, {
  group = au_vimrc_settings,
  callback = function()
    vim.cmd.wviminfo()
  end,
})

-- for nvim-ufo {{{
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
-- }}} for nvim-ufo
