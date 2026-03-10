local defaults = vim.fn.has('multi_byte') == 1
    and { placeholder = '⋯ ', countFormat = ' %s↘' }
    or { placeholder = '...', countFormat = ' %s' }

-- Global variables with defaults
vim.g.FoldText_placeholder = vim.g.FoldText_placeholder or defaults.placeholder
vim.g.FoldText_showCount   = vim.g.FoldText_showCount == nil and true or vim.g.FoldText_showCount
vim.g.FoldText_countFormat = vim.g.FoldText_countFormat or defaults.countFormat

local END_BLOCK_CHARS = {'end', '}', ']', ')', '})', '},', '}}}'}
local END_BLOCK_REGEX = [[\(^\s*\|\s*"\s*\)\(]] .. table.concat(END_BLOCK_CHARS, [[\|]]) .. [[\);\?$]]
local END_COMMENT_REGEX = [[\v\s*\*\/\s*$]]
local START_COMMENT_BLANK_REGEX = [[\v^\s*\/\*\*?$]]

local function get_fold_start_line_nr()
    local fold_start = vim.v.foldstart
    while vim.fn.getline(fold_start):match('^%s*$') do
        local next_line = vim.fn.nextnonblank(fold_start + 1)
        if next_line == 0 or next_line > vim.v.foldend then break end
        fold_start = next_line
    end
    return fold_start
end

local function get_width()
    -- Uses getwininfo[1].textoff to accurately subtract gutters (sign, fold, number)
    local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    return win_info.width - win_info.textoff
end

local function get_lines_count()
    if vim.g.FoldText_showCount then
        local fold_size = 1 + vim.v.foldend - vim.v.foldstart
        return string.format(vim.g.FoldText_countFormat, fold_size)
    end
    return ''
end

local function get_ending()
    local line_text = vim.fn.getline(vim.v.foldend)
    local fold_ending = line_text:sub(vim.fn.indent(vim.v.foldend) + 1)

    if vim.fn.match(fold_ending, END_BLOCK_REGEX) ~= -1 and fold_ending:match('^%s*"') then
        fold_ending = line_text:sub(vim.fn.indent(vim.v.foldend) + 3)
    end

    return fold_ending:gsub('%s+$', '')
end

local function get_beginning()
    local start_nr = get_fold_start_line_nr()
    local line = vim.fn.getline(vim.v.foldstart)

    if start_nr <= vim.v.foldend then
        local spaces = string.rep(' ', vim.bo.tabstop)
        line = vim.fn.getline(start_nr):gsub('\t', spaces)
    end

    local fold_ending = get_ending()
    if vim.fn.match(fold_ending, END_COMMENT_REGEX) ~= -1
       and vim.fn.match(vim.fn.getline(vim.v.foldstart), START_COMMENT_BLANK_REGEX) ~= -1 then
        local next_line = vim.fn.getline(vim.v.foldstart + 1):gsub([[\v\s*\*]], '')
        line = line .. next_line
    end
    return line
end

-- MAIN function exported to _G for v:lua access
function foldtext_fn()
    if vim.v.foldend == 0 then return '' end

    local fold_line = get_beginning() .. ' ' .. vim.g.FoldText_placeholder .. ' ' .. get_ending()
    local count = get_lines_count()

    -- Truncate/Combine with count
    local content_line = count .. vim.fn.strcharpart(fold_line, vim.fn.strwidth(count))
    local expansion = string.rep(' ', get_width())

    return content_line .. vim.fn.strcharpart(expansion, vim.fn.strwidth(content_line))
end

local plugins = {}
local function init_config()
    vim.opt.foldtext = "v:lua.foldtext_fn()"
end

return {
    plugins = plugins,
    init_config = init_config,
}
