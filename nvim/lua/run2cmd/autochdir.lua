local helpers = require('run2cmd.helper-functions')
local dir_names = { '.git', '.svn' }
local paths_exclude = { 'fixtures', '//' }
local cache = {}

local function find_root(buf_id, names)
  local file_path = vim.api.nvim_buf_get_name(buf_id)
  if file_path == '' then
    return
  end
  local path = vim.fs.dirname(file_path)

  local result = cache[path]
  if result ~= nil then
    return result
  end

  local root_file = vim.fs.find(names, { path = path, upward = true })[1]
  if root_file == nil then
    if vim.api.nvim_get_option_value('filetype', { buf = buf_id }) ~= '' then
      root_file = file_path
    else
      return
    end
  end

  for _, i in ipairs(paths_exclude) do
    if string.match(root_file, i) then
      return
    end
  end

  result = vim.fn.fnamemodify(vim.fs.dirname(root_file), ':p')

  cache[path] = result

  return result
end

local function set_root()
  local root = find_root(0, dir_names)
  if root == nil then
    return
  end
  vim.fn.chdir(root)
end

helpers.create_autocmds({
  projectautochdir = {
    { event = { 'BufEnter' }, opts = { callback = set_root } },
  },
})
