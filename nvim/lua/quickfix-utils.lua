local M = {}

-- quickfix next
M.cn = function()
    vim.cmd.cnext()
    vim.fn.timer_start(10, function() vim.cmd('FindCursor #d6d8fa 0') end)
end

-- quickfix prev
M.cp = function()
    vim.cmd.cprev()
    vim.fn.timer_start(10, function() vim.cmd('FindCursor #d6d8fa 0') end)
end

M.deduplicateQuickfixList = function()
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
    require('globalfind').resizeQFHeight()
end

return M
