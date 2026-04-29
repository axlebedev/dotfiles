local array = require('utils/array')
local resizeQFHeight = require('features/globalfind/resizeQFHeight')

local M = {}

local filtered = {
    'node_modules',
    'json',
    'test__',
    'git',
    'svg',
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
    'apps/[a-v]', 'apps/[x-z]',
    'apps/w[a-d]', 'apps/w[f-z]',
    'basket',
    'Content/j',
}
M.filterTestEntries = function()
    local list = vim.fn.getqflist()
    local res = {}

    for _, v in pairs(list) do
        local bufname = vim.fn.bufname(v.bufnr)
        if not array.some(filtered, function(v) return bufname:match(v) end) then
            table.insert(res, v)
        end
    end
    vim.fn.setqflist(res)
    resizeQFHeight()
end

return M
