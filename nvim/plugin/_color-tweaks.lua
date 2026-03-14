vim.opt.termguicolors = true
-- SpellBad
vim.api.nvim_set_hl(0, 'SpellBad', {
  bg = '#532120',
})

-- PmenuThumb
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#999999' })

-- Custom highlight links
vim.api.nvim_set_hl(0, 'ChaseChangedLetter', { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, 'ChaseSeparator', { link = 'DiffChange' })

-- Conceal (for unused warnings)
vim.api.nvim_set_hl(0, 'Conceal', { fg = 'NONE', bg = '#f6b7ac' })

-- Visual selection
vim.api.nvim_set_hl(0, 'Visual', { bg = '#ADCBFF', fg = 'NONE' })

-- Search highlights
vim.api.nvim_set_hl(0, 'QuickFixLine', { bg = '#cdadf7' })
vim.api.nvim_set_hl(0, 'Search', { bg = '#cdadf7', fg = 'NONE' })
vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#cdadf7', fg = 'NONE' })
vim.api.nvim_set_hl(0, 'CurSearch', { bg = '#ba91f2', fg = 'NONE' })

-- Highlightedyank
vim.api.nvim_set_hl(0, 'HighlightedyankRegion', { bg = '#acde95' })

-- MatchParen
vim.api.nvim_set_hl(0, 'MatchParen', {
  bold = true,
  bg = '#FDBED4',
  fg = 'NONE'
})

-- Fold column
vim.api.nvim_set_hl(0, 'FoldColumn', { bg = '#d9d9d9', fg = '#34352E' })
vim.api.nvim_set_hl(0, 'Folded', { bg = '#cee6eb' })
vim.api.nvim_set_hl(0, 'UfoFoldedBg', { bg = '#cee6eb' })

-- SignColumn
vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#d9d9d9' })

-- Clap autocmds (plugin-specific, likely OBSOLETE)
local clap_group = vim.api.nvim_create_augroup('ClapHighlights', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = clap_group,
  pattern = 'ClapOnExit',
  callback = function()
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#d9d9d9' })
  end,
})
vim.api.nvim_create_autocmd('User', {
  group = clap_group,
  pattern = 'ClapOnEnter',
  callback = function()
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#d9d9d9' })
  end,
})

-- vim-illuminate
vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#c1d3db", underline = true })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#c1d3db", underline = true })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#c1d3db", underline = true })

-- Line numbers
local sidebar_bg_cursor = '#e3e3e3'
vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = sidebar_bg_cursor, bold = true })
vim.api.nvim_set_hl(0, 'CursorLineSign', { bg = sidebar_bg_cursor, bold = true })
vim.api.nvim_set_hl(0, 'CursorLineFold', { bg = sidebar_bg_cursor, bold = true })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = sidebar_bg_cursor })

local sidebar_bg = '#CBCCCB'
vim.api.nvim_set_hl(0, 'LineNr', { bg = sidebar_bg })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = sidebar_bg })
vim.api.nvim_set_hl(0, 'FoldColumn', { bg = sidebar_bg })
-- VertSplit
vim.api.nvim_set_hl(0, 'VertSplit', { bg = sidebar_bg, fg = '#d9d9d9' })

-- ALE (skip if not using ALE)
vim.api.nvim_set_hl(0, 'ALESignColumnWithErrors', { bg = '#f6b7ac' })

-- Diff / GitSigns
vim.api.nvim_set_hl(0, 'diffAdded', { bg = '#d0f2d4', fg = 'NONE' })
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#d0f2d4', fg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#b1f5b9', bg = '#b1f5b9' })

vim.api.nvim_set_hl(0, 'diffRemoved', { bg = '#f2d1ce', fg = 'NONE' })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#f2d1ce', fg = 'NONE' })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#f2b7b1', bg = '#f2b7b1' })

vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#ebdfce', fg = 'NONE' })
vim.api.nvim_set_hl(0, 'diffChanged', { bg = '#ebdfce', fg = 'NONE' })
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#ffe79f', bg = '#ffe79f' })
vim.api.nvim_set_hl(0, 'diffFile', { bg = '#ebdfce', fg = 'NONE' })
vim.api.nvim_set_hl(0, 'diffLine', { bg = '#ebdfce', fg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#ebdfce', fg = 'NONE', bold = true })

-- Popup scrollbar
vim.api.nvim_set_hl(0, 'PopupScrollbar', { fg = '#A7A7A7', bg = 'NONE' })

-- Indexed search popup
vim.api.nvim_set_hl(0, 'IndexedSearchPopup', { bold = true, bg = '#FDBED4', fg = 'NONE' })

-- Coc
vim.api.nvim_set_hl(0, 'CocCodeLens', { link = 'Comment' })

-- TODO: when supported
-- highlight link ChaseChangedLetter DiffAdd
-- highlight link ChaseSeparator DiffChange

vim.api.nvim_set_hl(0, 'MoreMsg', { bg = '#cecfeb', bold = true })

vim.api.nvim_set_hl(0, 'SnacksIndentScope', { fg = '#979797' })
