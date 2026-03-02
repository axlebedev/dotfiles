local resizeQFHeight = require('features/globalfind/resizeQFHeight')


-- Uniq по файлам
local uniqFilesQF = function()
    -- Dictionary to track seen files
    local seen_files = {}

    -- New list to store deduplicated entries
    local new_quickfix_list = {}

    -- Iterate through the current quickfix list
    for _, entry in pairs(vim.fn.getqflist()) do
        local filepath = vim.fn.bufname(entry.bufnr)  -- Get the file path from the entry
        if seen_files[filepath] == nil then
            -- Add the entry to the new list if the file hasn't been seen
            table.insert(new_quickfix_list, entry)
            seen_files[filepath] = true  -- Mark the file as seen
        end
    end

    -- Replace the quickfix list with the deduplicated list
    vim.fn.setqflist(new_quickfix_list)
    resizeQFHeight()
end

return uniqFilesQF
