local init_config = function()
    -- Quickfix wrap (native)
    vim.api.nvim_create_user_command(
        'Cnext', 
        'try | cnext | catch | cfirst | catch | endtry', 
        {})

    vim.api.nvim_create_user_command(
        'Cprev', 
        'try | cprev | catch | clast | catch | endtry', 
        {})

    vim.api.nvim_create_user_command(
        'Lnext', 
        'try | lnext | catch | lfirst | catch | endtry', 
        {})

    vim.api.nvim_create_user_command(
        'Lprev', 
        'try | lprev | catch | llast | catch | endtry', 
        {})

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
