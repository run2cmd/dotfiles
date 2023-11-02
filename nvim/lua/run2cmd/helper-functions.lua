local mapkey = vim.keymap.set
local M = {}

--
-- Default float window parameters
--
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

--
-- Validate if table contains string pattern.
--
-- @param table Table to match against.
-- @param pattern Regex pattern to validate if it's in table.
--
-- @return true if table contains string pattern, false otherwise
--
M.table_contains = function(table, pattern)
  local exists = false
  for _, v in pairs(table) do
    if v == pattern then
      exists = true
    end
  end
  return exists
end

--
-- Merge map arrays
--
-- @param ... Each parameter needs to be map array. Order matters and counts from lowest to highest priority.
--
-- @return map array of merged items.
--
M.merge = function(...)
  local tbl = {}
  for _, i in ipairs({ ... }) do
    for k, v in pairs(i) do
      tbl[k] = v
    end
  end
  return tbl
end

--
-- Concentrate arrays
--
-- @param ... Each parameter needs to be array.
--
-- @return array
--
M.concat = function(...)
  local tbl = {}
  for _, i in ipairs({ ... }) do
    for _, v in pairs(i) do
      table.insert(tbl, v)
    end
  end
  return tbl
end

--
-- Validate if filepath exists.
--
-- @param path Path to file. Can be relative or absolute.
--
-- @return true if file exists, false otherwise
--
M.file_exists = function(path)
  local file = io.open(path, 'r')
  return file ~= nil and io.close(file)
end

--
-- Helper for creation auto commands
--
-- @param map Table that contains autcommands where key is autocmd group name and value is table of autocommands
--   @field event Event on which autocmd executes
--   @field opts Additional options to use for nvim_create_autocmd function
--
-- @example
--   local autocmds = {
--     filetypes = {
--       event = { 'BufNewFile' },
--       opts = { pattern = '*.lua', command = ':LspStart' }
--   }
--   create_autocmds(autocmds)
M.create_autocmds = function(map)
  for group_name, cmds in pairs(map) do
    vim.api.nvim_create_augroup(group_name, { clear = true })
    for _, v in pairs(cmds) do
      v.opts.group = group_name
      vim.api.nvim_create_autocmd(v.event, v.opts)
    end
  end
end

--
-- Display provided text in floating window
--
-- @param ftext List of items to display in floating window.
-- @param fopts Additional float window options. See nvim_open_win help.
--
M.float_text = function(ftext, fopts)
  local buf = vim.api.nvim_create_buf(false, true)
  local opts = default_float_params(fopts)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, ftext)
  vim.api.nvim_open_win(buf, 1, opts)
end

--
-- Open file in float window
--
-- @param ftext List of items to display in floating window.
-- @param fopts Additional float window options. See nvim_open_win help.
--
M.float_buffer = function(filepath, fopts)
  local buf = vim.api.nvim_create_buf(false, true)
  local opts = default_float_params(fopts)
  vim.api.nvim_open_win(buf, 1, opts)
  vim.cmd.edit(filepath)
  mapkey('n', '<ESC>', ':q<cr>', { buffer = true })
  mapkey('n', '<c-v>', ':q | e' .. filepath .. '<cr>', { buffer = true })
end

--
-- Read output from external command.
--
-- @param cmd Command which outut we want to read.
--
M.cmd_output = function(cmd)
  local output = ''
  local handle = io.popen(cmd)
  if handle ~= nil then
    output = handle:read('*a'):gsub('\n', '')
    handle:close()
  end
  return output
end

--
-- Match pattern against buffer content
--
-- @param buf Buffer number.
-- @param pattern Pattern for string match.
-- @param num_lines Number of lines from buffet to match against.
--
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
