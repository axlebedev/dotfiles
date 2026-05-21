local M = {}

local restricted = {'index', 'viewModel', 'types'}
local function isRestricted(value)
    for _, v in ipairs(restricted) do
        if v == value then return true end
    end
    return false
end

local function getBaseFilename(filename)
    local base = filename:match('^(.*)%.[^%.]+$')
    return base or filename
end

M.getValue = function(path)
    local dirs = require('utils/string').split(path, '/')
    if #dirs == 0 then return '' end
    local filename = table.remove(dirs, #dirs)
    local baseFilename = getBaseFilename(filename)

    if not isRestricted(baseFilename) then
        return filename
    end

    local res = filename
    while #dirs > 0 do
        local tail = table.remove(dirs)
        res = tail .. '/' .. res
        if not isRestricted(tail) then
            return res
        end
    end
    return res
end

return M
