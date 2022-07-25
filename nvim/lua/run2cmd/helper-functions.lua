local M = {}

local function table_contains(table, pattern)
  local exists = false
  for k, v in pairs(table) do
    if v == pattern then
      exists = true
    end
  end
  return exists
end

M.chtsh = function(params)
  local buffer = vim.t.doc_window_buffer
  if buffer and vim.api.nvim_buf_is_valid(buffer) then
    vim.api.nvim_buf_delete(buffer)
  end
  vim.cmd('split term://chtsh.sh ' .. params)
  vim.t.doc_window_buffer = vim.api.nvim_get_current_buf()
end

M.goto_last_position = function()
  if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
    vim.cmd("normal! g'\"")
  end
end

M.autosave = function()
  local buffer = vim.api.nvim_get_current_buf()
  local excluded = { 'terminal', 'nofile', 'finished', 'gitcommit', 'startify' }

  if vim.api.nvim_buf_get_name(buffer) ~= '' then
    local modified = vim.api.nvim_buf_get_option(buffer, 'modified')
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = buffer })
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = buffer })

    if modified then
      if table_contains(excluded, filetype) or table_contains(excluded, buftype) then
        return
      else
        vim.cmd('write')
      end
    end
  end
end

M.set_filetype = function(ft, syn)
  local buffer = vim.api.nvim_get_current_buf()
  local hosts_matcher = vim.filetype.match({ buf = buffer, contents = {'- hosts:'} })
  local name_matcher = vim.filetype.match({ buf = buffer, contents = {'- name:'} })
  if hosts_matcher or name_matcher then
    vim.bo.filetype = ft
    vim.bo.syntax = syn
  end
end

return M
