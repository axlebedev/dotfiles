-- Variable to track the last used Insert-mode layout (default to 1)
local last_insert_layout = 1

-- Group to prevent duplicate autocommands if config reloads
local xkb_group = vim.api.nvim_create_augroup("GsettingsXkbSwitch", { clear = true })

-- Function to switch to Normal mode layout (0) and save current layout
local function save_and_set_normal()
  -- Read current active GNOME layout index
  local handle = io.popen("gsettings get org.gnome.desktop.input-sources current 2>/dev/null")
  local result = handle:read("*a"):gsub("^%s*(.-)%s*$", "%1")
  handle:close()

  -- Extract digits from output string
  local current = result:match("%S+$"):gsub("^%s*(.-)%s*$", "%1")
  if current then
    last_insert_layout = current
  end

  -- Force switch back to layout 0 for Normal mode commands
  os.execute("gsettings set org.gnome.desktop.input-sources current 0 >/dev/null 2>&1")
end

-- Function to restore the layout saved during insert mode
local function restore_insert()
  os.execute("gsettings set org.gnome.desktop.input-sources current " .. last_insert_layout .. " >/dev/null 2>&1")
end

-- Create the InsertLeave autocommand
vim.api.nvim_create_autocmd("InsertLeave", {
  group = xkb_group,
  pattern = "*",
  callback = save_and_set_normal,
})

-- Create the InsertEnter autocommand
vim.api.nvim_create_autocmd("InsertEnter", {
  group = xkb_group,
  pattern = "*",
  callback = restore_insert,
})
