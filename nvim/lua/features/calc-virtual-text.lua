-- save in lua/auto_calculate.lua
-- load in you init file with `require("auto_calculate")`
-- Shows math expression results as virtual text at the end of each line.
-- Works in markdown files. Supports: +, -, *, /, parentheses, decimals.
--
-- Example:
--   "2 * (20 + 1)"  →  displays "= 42" as dimmed virtual text
--   "- 100 / 3"     →  displays "= 33.333333" (markdown list item)
--   "hello world"   →  no virtual text (not a math expression)

local ns = vim.api.nvim_create_namespace("calc-virtual-text")

--- Safely evaluate a math expression using Lua's load().
--- Uses Lua's native float arithmetic so 10/3 = 3.3333... (not integer division).
---@param expr string Raw line text from the buffer
---@return string|nil result Evaluated result, or nil if not a valid expression
local function safe_eval(expr)
  if not expr or expr == "" then
    return nil
  end

  -- Strip markdown list prefixes: "- " or "* "
  local cleaned = expr:gsub("^%s*[%-*]%s+", "")

  -- Remove trailing "= ..." so re-evaluation works on "2 + 2 = 4"
  cleaned = cleaned:gsub("%s*=.*$", "")
  cleaned = vim.trim(cleaned)

  if cleaned == "" then
    return nil
  end

  -- Require at least one math operator
  if not cleaned:match("[%+%-%*/]") then
    return nil
  end

  -- Whitelist: only digits, operators, parens, dots, spaces, tabs.
  -- This is the security boundary — load() will only ever see
  -- arithmetic expressions, never arbitrary Lua code.
  if cleaned:match("[^%d%+%-%*/%.%(%)\t ]") then
    return nil
  end

  -- Require a real operation: digit, operator, digit/paren.
  -- Rejects bare numbers like "42" or isolated operators
  if not cleaned:match("%d[%s]*[%+%-%*/][%s]*[%d%(]") then
    return nil
  end

  -- load() compiles a Lua chunk; "return ..." makes it an expression.
  -- Lua numbers are always floats, so 10/3 = 3.3333... not 3.
  local fn, err = load("return " .. cleaned)
  if not fn then
    return nil
  end

  local ok, result = pcall(fn)
  if not ok or result == nil then
    return nil
  end

  -- Format result: clean up float representation
  local str = tostring(result)
  if str:match("%.") then
    -- Strip trailing zeros: "4.00" → "4", "3.50" → "3.5"
    str = str:gsub("0+$", ""):gsub("%.$", "")
  end

  return str
end

--- Render virtual text with evaluation results for every line in the buffer.
---@param bufnr number Buffer handle
local function update_virtual_text(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    local result = safe_eval(line)
    if result then
      vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
        virt_text = { { " = " .. result, "Comment" } },
        virt_text_pos = "eol",
      })
    end
  end
end

-- Attach to markdown buffers and re-evaluate on every text change
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(ev)
    local bufnr = ev.buf

    update_virtual_text(bufnr)

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
      buffer = bufnr,
      callback = function()
        update_virtual_text(bufnr)
      end,
    })
  end,
})
