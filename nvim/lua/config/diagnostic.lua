local init_config = function()
    vim.keymap.set('n', '<C-m>', function() vim.diagnostic.jump({ count = 1, float = true }) end, { noremap = true, silent = true })
    vim.keymap.set('n', '<C-n>', function() vim.diagnostic.jump({ count = -1, float = true }) end, { noremap = true, silent = true })

    vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "●", -- Example: a red circle
                    [vim.diagnostic.severity.WARN]  = "▲", -- Example: a yellow triangle
                    [vim.diagnostic.severity.INFO]  = "i",
                    [vim.diagnostic.severity.HINT]  = "?",
                },
                -- You can also configure highlights, etc.
            },
            update_in_insert = true,
            float = {
                header = false,
                border = 'rounded',
            }
        })

    -- for eslint
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
            pattern = "*",
            callback = function()
                for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                    if vim.api.nvim_win_get_config(winid).zindex then
                        return
                    end
                end
                vim.diagnostic.open_float({
                        scope = "cursor",
                        focusable = false,
                        close_events = {
                            "CursorMoved",
                            "CursorMovedI",
                            "BufHidden",
                            "InsertEnter",
                            "TextChanged",
                            "WinLeave",
                        },
                    })
            end
        })

end

return { init_config = init_config }
