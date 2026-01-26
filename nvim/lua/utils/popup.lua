local M = {}

M.createPopup = function(text, width) 
    -- Create the scratch buffer displayed in the floating window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, 1, false, { text })

    -- Get the current UI
    local ui = vim.api.nvim_list_uis()[0]
    print(vim.inspect(ui))

    -- Create the floating window
    local opts = {
        relative = 'editor',
        width = width,
        height = 1,
        col = 0,
        row = 50,
        anchor = 'NW',
        style = 'minimal',
        focusable = false,
        mouse = false,
        fixed = true,
    }
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
