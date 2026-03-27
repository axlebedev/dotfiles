local ResizeQFHeight = require('features/globalfind/resizeQFHeight')
local utils = require('utils/utils')

local M = {}

-- Когда находимся в буфере quickfix – удаляем элемент из quickfix листа,
-- иначе — строку в обычном буфере.
function M.RemoveQFItem()
  local filename = vim.fn.expand("%")
  if #filename > 0 then
    vim.api.nvim_del_current_line()
    return
  end

  local curpos = vim.fn.getpos(".")
  local winview = vim.fn.winsaveview()
  local qfall = vim.fn.getqflist()
  local curqfidx = vim.fn.line(".")

  table.remove(qfall, curqfidx)

  vim.fn.setqflist(qfall, "r")
  vim.fn.winrestview(winview)
  vim.fn.setpos(".", curpos)
end

function M.RemoveQFItemsVisual()
  local curpos = vim.fn.getpos(".")
  local vpos = vim.fn.getpos("v")

  local line_start = math.min(curpos[2], vpos[2]) + 1
  local line_end   = math.max(curpos[2], vpos[2]) + 1

  local filename = vim.fn.expand("%")
  if #filename > 0 then
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, false, {})
    return
  end

  local winview = vim.fn.winsaveview()
  local qfall = vim.fn.getqflist()

  local qfnew
  if line_start < 2 then
    -- qfall[lineEnd : ]
    qfnew = {}
    for i = line_end, #qfall do
      qfnew[#qfnew + 1] = qfall[i]
    end
  else
    -- qfall[ : lineStart - 2] + qfall[lineEnd : ]
    qfnew = {}
    for i = 1, line_start - 2 do
      qfnew[#qfnew + 1] = qfall[i]
    end
    for i = line_end, #qfall do
      qfnew[#qfnew + 1] = qfall[i]
    end
  end

  vim.fn.setqflist(qfnew, "r")
  vim.fn.winrestview(winview)
  vim.cmd(("normal! %dG"):format(line_start))
  vim.cmd("normal! " .. vim.fn.mode())
end

function M.FilterQFWithWord(word)
  local curpos = vim.fn.getpos(".")
  local winview = vim.fn.winsaveview()

  local filename = vim.fn.expand("%")
  if #filename > 0 then
    vim.api.nvim_del_current_line()
    return
  end

  local qfall = vim.fn.getqflist()

  -- Эквивалент filter() с выражением:
  -- 'v:val.text !~? "word" && bufname(v:val.bufnr) !~? "word"'
  local new_qf = {}
  for _, item in ipairs(qfall) do
    local text = item.text or ""
    local bufname = vim.fn.bufname(item.bufnr or 0)
    if not (text:lower():find(word:lower(), 1, true) or bufname:lower():find(word:lower(), 1, true)) then
      new_qf[#new_qf + 1] = item
    end
  end

  vim.fn.setqflist(new_qf, "r")
  vim.fn.winrestview(winview)
  vim.fn.setpos(".", curpos)

  ResizeQFHeight()
end

function M.FilterQF(is_visual_mode)
  local initialWord = vim.fn.mode() ~= 'n'
  and utils.get_visual_selection()
  or vim.fn.expand('<cword>')

  local word = vim.fn.input("Filter entries with text: ", initial_word)
  if word == nil or word == "" then
    return
  end

  M.FilterQFWithWord(word)
end

return M
