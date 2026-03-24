local utils = require('utils/utils')
local plugins = {
}
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
                vim.wo.cursorline = true
                vim.keymap.set("n", "o", "<CR>", { buffer = true, silent = true })
                vim.keymap.set("n", "<CR>", "<CR>", { buffer = true, silent = true })
                vim.keymap.set("n", "q", "<cmd>cclose | wincmd l<cr>", { buffer = true, silent = true, remap = true })
                vim.keymap.set('n', 'yy', '02f|wy$', { buffer = true, silent = true })
                vim.keymap.set('n', '<leader>t', function()
                    vim.cmd('wincmd k | wincmd l')
                    vim.cmd('Telescope find_files hidden=true')
                end, { buffer = true, silent = true })
                vim.keymap.set('n', '<C-k>', function()
                    vim.cmd('wincmd k | wincmd l')
                end, { buffer = true, silent = true })

                vim.api.nvim_set_hl(0, 'qfLineNr', { fg = '#ef7932', bold = true })

                -- qf не должен залезать под nvimtree {{{
                local nvimtreeapi = require("nvim-tree.api")
                local is_open = nvimtreeapi.tree.is_visible()
                if (is_open) then
                    -- вся история ниже делает правильную картинку, но создаёт мерцание
                    -- поэтому где можем - пишем 'hor copen'
                    vim.schedule(function()
                        nvimtreeapi.tree.focus()
                        local nt_width = vim.api.nvim_win_get_width(0)
                        vim.cmd.wincmd("H")
                        vim.api.nvim_win_set_width(0, nt_width)
                        vim.cmd.wincmd("p")
                    end)
                end
                -- }}}
            end,
        })

    -- format lines in qf
    function _G.qftf(info)
        local items, ret = {}, {}
        -- Fetch items based on whether it's a quickfix or location list
        if info.quickfix == 1 then
            items = vim.fn.getqflist({ id = info.id, items = 0 }).items
        else
            items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
        end

        for i = info.start_idx, info.end_idx do
            local e = items[i]
            local fname = e.bufnr > 0 and vim.fn.bufname(e.bufnr) or ""
            -- Shorten home directory to ~
            fname = vim.fn.fnamemodify(fname, ":."):gsub("^" .. vim.env.HOME, "~"):gsub("^%.%/", "")

            -- Format: filename:line:col: type text
            local str = string.format("%s|%d|  %s", fname, e.lnum, utils.trim(e.text))
            table.insert(ret, str)
        end
        return ret
    end

    -- Enable the custom function
    vim.o.quickfixtextfunc = "{info -> v:lua._G.qftf(info)}"

    vim.keymap.set("n", "co", function()
        local isQuickfixHere = require('utils/array').some(
            vim.fn.getwininfo(),
            function(i) return i.quickfix ~= 0 end
            )
        if isQuickfixHere then
            if vim.bo.filetype == "qf" then
                vim.cmd('cclose | wincmd l')
            else
                vim.cmd('cclose')
            end
        else
            vim.cmd.copen()
        end
    end, { desc = "Toggle quickfix", })
end

return {
    plugins = plugins,
    init_config = init_config
}
