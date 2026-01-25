local M = {}

-- update current file
local function updateBufferInner(isForce)
    local view = vim.fn.winsaveview()
    vim.cmd(isForce and 'e!' or 'e')
    vim.fn.winrestview(view)
end

M.updateBuffer = function() updateBufferInner(false) end
M.updateBufferForce = function() updateBufferInner(true) end

return M
