-- 1. Create a dedicated namespace for this virtual text
local path_ns = vim.api.nvim_create_namespace("LineFilePath")

local function clear_virttext(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, path_ns, 0, -1)
end

-- 2. Define the toggle function
local function toggle_file_path_virtual_text()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get the current cursor position (0-indexed line)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

  -- Check if our virtual text already exists on this line
  -- We query extmarks in our specific namespace on the current line
  local existing = vim.api.nvim_buf_get_extmarks(
    bufnr,
    path_ns,
    { cursor_line, 0 },
    { cursor_line, -1 },
    {}
  )

  -- If it already exists, clear it (Toggle Off)
  if #existing > 0 then
    return clear_virttext(bufnr)
  end

  -- Otherwise, clear any old ones elsewhere and create a new one (Toggle On)
  vim.api.nvim_buf_clear_namespace(bufnr, path_ns, 0, -1)

  -- Fetch the absolute path of the current buffer
  local file_path = vim.api.nvim_buf_get_name(bufnr)
  if file_path == "" then
    file_path = "[No Name]"
  end
  local rel_path = vim.fn.fnamemodify(file_path, ":.")

  -- Apply the virtual text at window column 0
  vim.api.nvim_buf_set_extmark(bufnr, path_ns, cursor_line, 0, {
    virt_text = { { rel_path, "Comment" } }, -- Using "Comment" highlight group for a clean look
    virt_text_win_col = 0,                    -- Forces it to start at column 0 of the window
    hl_mode = "combine",
  })
end

-- 3. Map the function to the "P" key in Normal mode
vim.keymap.set("n", "P", toggle_file_path_virtual_text, {
  desc = "Toggle current file path as virtual text on column 0",
  silent = true,
})

-- 5. Auto-cleanup on cursor move or buffer change
local path_group = vim.api.nvim_create_augroup("LineFilePathGroup", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave" }, {
  group = path_group,
  callback = function(args)
    clear_virttext(args.buf)
  end,
})
