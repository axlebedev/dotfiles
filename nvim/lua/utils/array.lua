local M = {}

M.some = function(arr, cb)
  for _, item in pairs(arr) do
    if cb(item) then
      return true 
    end
  end
  return false
end

M.map = function(arr, cb)
  local result = {}
  for _, item in pairs(arr) do
    table.insert(result, cb(item))
  end
  return result
end

M.join = function(arr, separator)
  local result = arr[1]
  for i, item in pairs(arr) do
    if i > 1 then
      result = result .. separator .. item
    end
  end
  return result
end

M.index = function(arr, value)
  for i, item in pairs(arr) do
    if value == item then
      return i
    end
  end
  return -1
end

return M
