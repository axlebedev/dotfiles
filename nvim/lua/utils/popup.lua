local M = {}

M.createPopup = function(text, opts)
    -- Create the scratch buffer displayed in the floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, 1, false, type(text) == 'string' and { text } or text)

    -- Get the current UI
    -- local ui = vim.api.nvim_list_uis()[0]

    -- Create the floating window
    local defaultOpts = {
        relative = 'editor',
        width = 10,
        height = 1,
        col = 0,
        row = 999,
        anchor = 'NW',
        style = 'minimal',
        focusable = false,
        mouse = false,
        fixed = true,
        border = 'rounded',
    }
    for k, v in pairs(defaultOpts) do
        if opts[k] == nil then
            opts[k] = v
        end
    end
    local win = vim.api.nvim_open_win(buf, 1, opts)
    vim.cmd('redraw')

    vim.cmd('wincmd p')

    return buf, win
end

M.closePopup = function(winId)
    vim.api.nvim_win_close(winId, true)
    vim.cmd('redraw')
end

M.updateText = function(buf, text)
    vim.api.nvim_buf_set_lines(buf, 0, 1, false, { text })
    vim.cmd('redraw')
end

return M
