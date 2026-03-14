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
    end
    vim.fn.timer_start(10, function() vim.cmd('FindCursor #d6d8fa 0') end)
  end)
end

return {
  plugins = plugins,
  init_config = init_config
}
