local init_config = function()
    vim.api.nvim_create_autocmd("FileType", {
            pattern = "qf",
            callback = function()
                vim.keymap.set("n", "o", "<CR>", { buffer = true, silent = true })
                vim.keymap.set("n", "<CR>", "<CR>", { buffer = true, silent = true })
                vim.keymap.set("n", "q", "<cmd>cclose | wincmd l<cr>", { buffer = true, silent = true, remap = true })
            end,
        })
end

return {
    init_config = init_config
}
