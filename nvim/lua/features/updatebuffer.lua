-- update current file
local function updateBufferInner(isForce)
    local view = vim.fn.winsaveview()
    vim.cmd(isForce and 'e!' or 'e')
    vim.fn.winrestview(view)
end

local updateBuffer = function() updateBufferInner(false) end
local updateBufferForce = function() updateBufferInner(true) end

vim.keymap.set('n', '<F5>', updateBuffer)
vim.keymap.set('n', '<F5><F5>', updateBufferForce)
