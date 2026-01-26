-- Skip quickfix on traversing buffers
local M = {}
local openNextBufInner = function(isPrev)
    local command = isPrev and "bprev" or "bnext"
    vim.cmd(command)
    if vim.bo.buftype == 'quickfix' or vim.bo.buftype == 'terminal' then
        M.openNextBuf(isPrev)
    end
end

M.openNextBuf = function() openNextBufInner(false) end
M.openPrevBuf = function() openNextBufInner(true) end

return M
