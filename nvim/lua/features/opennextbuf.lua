-- Skip quickfix on traversing buffers
local openNextBuf = function(isPrev)
    local command = isPrev and "bprev" or "bnext"
    vim.cmd(command)
    if vim.bo.buftype == 'quickfix' or vim.bo.buftype == 'terminal' then
        M.openNextBuf(isPrev)
    end
end

vim.keymap.set("n", "<leader>k", function() openNextBuf(false) end)
vim.keymap.set("n", "<leader>j", function() openNextBuf(true) end)
