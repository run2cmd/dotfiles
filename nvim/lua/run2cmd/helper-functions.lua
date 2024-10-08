local mapkey = vim.keymap.set
local M = {}

local function default_float_params()
  local ui = vim.api.nvim_list_uis()[1]
  local height = 10
  local widht = 100
  local defaults = {
    relative = 'editor',
    width = widht,
    height = height,
    col = (ui.width/2) - (widht/2),
    row = (ui.height/2) - (height/2),
    anchor = 'NW',
    style = 'minimal',
    noautocmd = true,
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

M.open_tmux = function()
  vim.cmd('silent !tmux split && tmux resize-pane -D 14')
  vim.wait(1500, function() end)
end

M.tmux_id = function()
  local id = '0'
  local panes = vim.api.nvim_exec2(
    '!tmux list-panes -F "\\#D" ' ..
    '-f "\\#{m:bottom,\\#{?pane_at_bottom,bottom,}}" '..
    '-f "\\#{?\\#{m:nvim,\\#{pane_current_command}},0,1}"',
    { output = true }
  )
  for pane_id in string.gmatch(panes.output, "[^\r\n]+") do
    if string.match(pane_id, "^%%") then
      id = pane_id
    end
  end
  return id
end

M.tmux_cmd = function(id, cmd)
  vim.cmd(string.format('silent !tmux send -t \\%s -X cancel', id))
  vim.cmd(string.format('silent !tmux send -t \\%s "%s" ENTER', id, cmd))
end

M.yank_registers = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't' }

return M
