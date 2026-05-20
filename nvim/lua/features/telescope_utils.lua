local M = {}

-- 1. Define distinct highlight groups for each nested directory level
local path_colors = {
  "TelescopePathDir1",
  "TelescopePathDir2",
}

vim.api.nvim_set_hl(0, "TelescopePathDir1", { })
vim.api.nvim_set_hl(0, "TelescopePathDir2", { fg = "#3c4691" })
vim.api.nvim_set_hl(0, "TelescopeFilename", { fg = "#943999", bold = true })

-- 2. Define a custom path formatter function
M.rainbow_path_display = function(opts, path)
  if (#path > vim.api.nvim_win_get_width(0) - 4) then
    path = "…" .. string.sub(path, -(vim.api.nvim_win_get_width(0) - 5))
  end

  -- Split path into directory parts and the file name
  local parts = {}
  for part in string.gmatch(path, "[^/]+") do
    table.insert(parts, part)
  end

  local filename = table.remove(parts) or ""
  local highlights = {}
  local display_str = ""
  local current_pos = 0

  -- Build directory components with alternating colors
  for i, folder in ipairs(parts) do
    local folder_str = folder .. "/"
    display_str = display_str .. folder_str

    -- Pick color based on folder depth (loops if path is deeper than available colors)
    local color_idx = ((i - 1) % #path_colors) + 1
    local hl_group = path_colors[color_idx]

    table.insert(highlights, {
      { current_pos, current_pos + #folder_str - 1 }, -- highlight range
      hl_group
    })
    current_pos = current_pos + #folder_str
  end

  display_str = display_str .. filename
  -- Calculate start and end indices of the filename string, then push to highlights
  if #filename > 0 then
    table.insert(highlights, {
      { current_pos, current_pos + #filename },
      "TelescopeFilename",
      99999 -- priority
    })
  end

  return display_str, highlights
end

return M
