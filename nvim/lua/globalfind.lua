local array = require('utils/array')
local popup = require('utils/popup')
local utils = require('utils/utils')

local M = {}

local ignored = {
    'dist',
    'package-lock.json',
    'yarn.lock',
    'dist',
    '.git',
    'stats.json',
    '.ccls-cache',
    '.tmp'
}

local ignoredList = array.join(array.map(ignored, function(item) return '--iglob !' .. item end), ' ')

local basegrepprg = 'rg --hidden --vimgrep ' .. ignoredList

local charsForEscape = '*'
-- -w --word-regexp
local isWholeWord = false
-- -Q --literal
local isLiteral = false
-- case
-- -i --ignore-case        Match case insensitively
-- -s --case-sensitive     Match case sensitively
-- -S --smart-case         Match case insensitively unless PATTERN contains
--                         uppercase characters (Enabled by default)
local caseArray = {'--smart-case', '-i', '-s'}
local case = caseArray[1]

vim.opt.grepprg = basegrepprg

local popupBuf = -1
local popupWun = -1

local function caseToString() 
    if case == caseArray[1] then
        return '－'
    elseif case == caseArray[2] then
        return '➕'
    end
    return 'S'
end

local function resizeQFHeight()
    local qfLength = #vim.fn.getqflist()
    if qfLength == 0 then
        return
    end

    local height = math.min(qfLength + 1, math.floor(vim.o.lines / 2))
    vim.cmd.resize(height)
    vim.cmd('normal! zb')
end

local function makeVarsString()
    return ' w' .. (isWholeWord and '➕' or '－')
        .. ' l' .. (isLiteral and '➕' or '－')
        .. ' i' .. caseToString() .. ' '
end

local function incWord()
    isWholeWord = not isWholeWord
    popup.updateText(popupBuf, makeVarsString())
end

local function incLiteral()
    isLiteral = not isLiteral
    popup.updateText(popupBuf, makeVarsString())
end

local function incCase()
    local nextCaseIndex = (array.index(caseArray, case) + 1) % #caseArray + 1
    case = caseArray[nextCaseIndex]
    popup.updateText(popupBuf, makeVarsString())
end

M.Grep = function()
    vim.keymap.set("c", "<C-w>", incWord)
    vim.keymap.set("c", "<C-l>", incLiteral)
    vim.keymap.set("c", "<C-i>", incCase)

    local initialWord = vim.fn.mode() ~= 'n'
        and utils.get_visual_selection()
        or vim.fn.expand('<cword>')

    local varsString = makeVarsString()

    local varsStringWidth = vim.api.nvim_strwidth(varsString)
    popupBuf, popupWin = popup.createPopup(varsString, varsStringWidth)

    local word = vim.fn.input(
        'Search > ',
        initialWord
    )

    -- Waiting for user input...
    popup.closePopup(popupWin)
    local savedIsLiteral = isLiteral
    if not isLiteral and word:find(vim.pesc(charsForEscape)) then
        incLiteral()
    end

    if not utils.empty(word) then
        isWholeWord = not isWholeWord
        isLiteral = not isLiteral
        word = vim.fn.shellescape(isLiteral and word or vim.fn.escape(word, charsForEscape)) 
        vim.fn.setreg('/', word)

        local prg = basegrepprg
        if isWholeWord then
            prg = prg .. ' -w'
        end
        if isLiteral then
            prg = prg .. ' -F'
        end
        prg = prg .. ' ' .. case

        local output = vim.fn.systemlist(prg .. ' ' .. word .. ' .')
        vim.fn.setqflist({}, ' ', { lines = output })
        vim.cmd('copen')
        resizeQFHeight()
    end

    isLiteral = savedIsLiteral
    vim.keymap.del('c', '<C-w>')
    vim.keymap.del('c', '<C-l>')
    vim.keymap.del('c', '<C-i>')
end

local filtered = {
    'node_modules',
    'json',
    'test__',
    'git',
    'diff',
    'commonMock',
    'yarn.lock',
    'fake-api',
    'api-types',
    'crowdin',
    'localization',
    'dictionaries',
    'spec.ts',
    'spec.js',
    'amrDocs',
    'amr-docs',
    'test',
    'Tests',
    'QtEditor',
    '--'
}
M.filterTestEntries = function()
    local list = vim.fn.getqflist()
    local res = {}

    for _, v in pairs(list) do
        local bufname = vim.fn.bufname(v.bufnr)
        if not array.some(filtered, function(v) return v:match(bufname) end) then
            table.insert(res, v)
        end
    end
    vim.fn.setqflist(res)
    resizeQFHeight()
end

return M
