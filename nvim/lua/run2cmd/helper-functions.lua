local mapkey = vim.keymap.set
local M = {}

local function default_float_params()
  local ui = vim.api.nvim_list_uis()[1]
  local height = 40
  local widht = 150
  local defaults = {
    relative = 'editor',
    width = widht,
    height = height,
    col = (ui.width/2) - (widht/2),
    row = (ui.height/2) - (height/2),
    anchor = 'NW',
    style = 'minimal',
    noautocmd = true,
    border = 'double',
  }
  return defaults
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

M.float_buffer = function(filepath)
  local buf = vim.api.nvim_create_buf(false, true)
  local opts = default_float_params()
  vim.api.nvim_open_win(buf, 1, opts)
  vim.cmd.edit(filepath)
  mapkey('n', '<Esc>',
    function()
      vim.api.nvim_buf_delete(0, { force = true })
    end, { buffer = true }
  )
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

M.tmux_cmd = function(cmd)
  local tmux_id = '{right}'
  local num_panes = vim.system({ 'tmux', 'display-message', '-p', '#{window_panes}' }, { text = true }):wait()['stdout']
  if tonumber(vim.trim(num_panes)) < 2 then
    vim.system({ 'tmux', 'split', '-h', cmd .. '&& bash' })
  else
    vim.system({ 'tmux', 'send', '-t', tmux_id, 'cd ' .. vim.fn.getcwd() .. ' && clear', 'ENTER' })
    vim.system({ 'tmux', 'send', '-t', tmux_id, '-X', 'cancel' })
    vim.system({ 'tmux', 'send', '-t', tmux_id, cmd, 'ENTER' })
  end
end

M.yank_registers = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't' }

return M
