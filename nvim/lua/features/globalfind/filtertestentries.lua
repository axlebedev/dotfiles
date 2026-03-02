local array = require('utils/array')
local resizeQFHeight = require('features/globalfind/resizeQFHeight')

local M = {}

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
