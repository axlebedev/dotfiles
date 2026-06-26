local initSearchPopup = function()
  vim.api.nvim_set_hl(0, "PopupPink", { bg = "#FFB6C1", fg = "#000000" })

  -- 1. Create an unlisted, scratch buffer for the popup content
  local buf = vim.api.nvim_create_buf(false, true)
  local opts = {
    relative = "cursor", -- Anchors the window position relative to the cursor
    row = 1,            -- Moves the popup 1 line directly below the cursor
    col = 0,            -- Aligns the popup horizontally with the cursor
    width = 3,          -- Width of the popup in characters
    height = 1,          -- Height of the popup in lines
    style = "minimal",   -- Strips UI bloat like line numbers and statuslines
  }
  local win = nil
  local timerId = nil

  function closeWinAndStopTimer()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if timerId then
      timerId:close()
      timerId = nil
    end
  end

  function openWinAndStartTimer()
    closeWinAndStopTimer()

    local result = vim.fn.searchcount({ maxcount = -1, timeout = 500 })
    local line = result.current .. '/' .. result.total
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { line })
    opts.width = #line

    -- Open the floating window (set false to keep focus on your current buffer)
    win = vim.api.nvim_open_win(buf, false, opts)
    vim.api.nvim_win_set_option(win, "winhighlight", "Normal:PopupPink")
    timerId = vim.uv.new_timer()
    timerId:start(1000, 0, vim.schedule_wrap(closeWinAndStopTimer))
  end

  vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
      pattern = "*",
      callback = function()
        vim.schedule(function()
          closeWinAndStopTimer()
          if vim.v.hlsearch == 0 then return end
          openWinAndStartTimer()
        end)
      end
    })

  return openWinAndStartTimer
end

local plugins = {
    -- clear hlsearch on cursor move
    { 'nvimdev/hlsearch.nvim',
      event = 'BufRead',
      config = function() require('hlsearch').setup() end
    },

    -- highlight 'f' character
    { 'rhysd/clever-f.vim',
      config = function()
        vim.g.clever_f_smart_case = 1
        vim.g.clever_f_across_no_line = 1
        vim.keymap.set('n', ';', '<Plug>(clever-f-repeat-forward)', { noremap = false })
      end,
    },
}

local init_config = function()
  local openWinAndStartTimer = initSearchPopup()
  -- на первом нажатии * - остаться на месте и включить hlsearch
  vim.keymap.set({ "n" }, "*", function()
    if vim.v.hlsearch == 1 then
      vim.api.nvim_feedkeys("*", "n", true)
    else
      local word = vim.fn.expand("<cword>")
      if word == "" then return "" end

      local pat = [[\V\<]] .. vim.fn.escape(word, [[/\]]) .. [[\>]]
      vim.fn.setreg("/", pat)
      vim.fn.histadd("/", pat)
      vim.o.hlsearch = true
      vim.fn.search(pat, "n")  -- 'n' flag = no movement
      openWinAndStartTimer()
    end
    vim.fn.timer_start(10, function() vim.cmd('FindCursor #d6d8fa 0') end)
  end)

end

return {
  plugins = plugins,
  init_config = init_config
}
