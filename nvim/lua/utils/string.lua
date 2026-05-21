local M = {}

M.split = function(s, separator)
    local parts = {}
    for part in string.gmatch(s, '[^' .. separator .. ']+') do
        table.insert(parts, part)
    end
    return parts
end

return M
