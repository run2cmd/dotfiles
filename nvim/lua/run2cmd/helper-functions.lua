local mapkey = vim.keymap.set
local M = {}

local function default_float_params(opts)
  local defaults = {
    relative = 'editor',
    width = 100,
    height = 10,
    col = 250,
    row = 0,
    anchor = 'NW',
    style = 'minimal',
    noautocmd = true,
  }
  return M.merge(defaults, opts)
end

M.table_contains = function(table, pattern)
  local exists = false
  for _, v in pairs(table) do
    if v == pattern then
      exists = true
    end
  end
  return exists
end

M.merge = function(...)
  local tbl = {}
  for _, i in ipairs({ ... }) do
    for k, v in pairs(i) do
      tbl[k] = v
    end
  end
  return tbl
end

M.concat = function(...)
  local tbl = {}
  for _, i in ipairs({ ... }) do
    for _, v in pairs(i) do
      table.insert(tbl, v)
    end
  end
  return tbl
end

M.file_exists = function(path)
  local file = io.open(path, 'r')
  return file ~= nil and io.close(file)
end

M.create_autocmds = function(map)
  for group_name, cmds in pairs(map) do
    vim.api.nvim_create_augroup(group_name, { clear = true })
    for _, v in pairs(cmds) do
      v.opts.group = group_name
      vim.api.nvim_create_autocmd(v.event, v.opts)
    end
  end
end

M.float_text = function(ftext, fopts)
  local buf = vim.api.nvim_create_buf(false, true)
  local opts = default_float_params(fopts)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, ftext)
  vim.api.nvim_open_win(buf, 1, opts)
end

M.float_buffer = function(filepath, fopts)
  local buf = vim.api.nvim_create_buf(false, true)
  local opts = default_float_params(fopts)
  vim.api.nvim_open_win(buf, 1, opts)
  vim.cmd.edit(filepath)
  mapkey('n', '<ESC>', ':q<cr>', { buffer = true })
  mapkey('n', '<c-v>', ':q | e' .. filepath .. '<cr>', { buffer = true })
end

M.cmd_output = function(cmd)
  local output = ''
  local handle = io.popen(cmd)
  if handle ~= nil then
    output = handle:read('*a'):gsub('\n', '')
    handle:close()
  end
  return output
end

M.buf_string_match = function(buf, pattern, num_lines)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, num_lines, false)
  local match = false
  for _, v in ipairs(lines) do
    if string.match(v, pattern) then
      match = true
    end
  end
  return match
end

return M
