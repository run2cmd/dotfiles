local helpers = require('run2cmd.helper-functions')

local function set_root()
  local root = helpers.find_root(0)
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
