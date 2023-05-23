local helpers = require('run2cmd.helper-functions')
local dir_names = { '.git', '.svn' }
local path_exclude = 'fixtures'
local cache = {}

-- Find project root directory
local function find_root(buf_id, names)
  local path = vim.api.nvim_buf_get_name(buf_id)
  if path == '' then return end
  path = vim.fs.dirname(path)

  -- Use cache
  local result = cache[path]
  if result ~= nil then return result end

  -- Find root
  local root_file = vim.fs.find(names, { path = path, upward = true })[1]
  if root_file == nil then return end

  -- Exclude dir name
  if string.match(root_file, path_exclude) then return end

  -- Use full path
  result = vim.fn.fnamemodify(vim.fs.dirname(root_file), ':p')

  -- Update cache
  cache[path] = result

  return result
end

 -- Change directory
 local function set_root()
  local root = find_root(0, dir_names)
  if root == nil then return end
  vim.fn.chdir(root)
end

helpers.create_autocmds({
  projectautochdir = {
    { event = { 'BufEnter'}, opts = { callback = set_root } }
  }
})