local M = {}

local ns = vim.api.nvim_create_namespace("timestamp_hint")
local updatetime_default = vim.o.updatetime

local saved_word = nil

local function clear()
    saved_word = nil
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end

local function parse_unix_at_cursor()
    local token = vim.fn.expand('<cword>')

    if vim.regex([[\v^\d{10,13}$]]):match_str(token) then
        return token
    end

    return nil
end

local function ts_to_date_str(ts)
    -- accept seconds (10 digits) or milliseconds (13 digits)
    if #ts == 13 then ts = tonumber(ts) / 1000 end
    ts = tonumber(ts)
    if not ts then return nil end
    -- format: 01.07.2026 12:34:56
    return os.date("%H:%M:%S %d %B %Y", ts)
end

function M.show()
    clear()

    saved_word = vim.fn.expand('<cword>')

    local token = parse_unix_at_cursor()
    if not token then return end
    local date = ts_to_date_str(token)
    if not date then return end
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1

    vim.api.nvim_buf_set_extmark(0, ns, row, -1, {
            virt_text = { { " ← " .. date, "Comment" } },
            virt_text_pos = "eol",
            hl_mode = "combine",
        })
end

-- autocmds: show on CursorHold, clear on movement/insert
vim.api.nvim_create_autocmd("CursorHold", {
        pattern = { "*" },
        callback = function() M.show() end,
    })

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter" }, {
        pattern = { "*" },
        callback = function()
            if saved_word ~= nil and saved_word ~= vim.fn.expand('<cword>') then
                clear()
            end
        end,
    })

return M
