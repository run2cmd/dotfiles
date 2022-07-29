local M = {}

--
-- Validate if table contains string pattern.
--
-- @param table Table to match against.
-- @param pattern Regex pattern to validate if it's in table.
--
-- @return true if table contains string pattern, false otherwise
--
local function table_contains(table, pattern)
  local exists = false
  for _, v in pairs(table) do
    if v == pattern then
      exists = true
    end
  end
  return exists
end

--
-- Run call to https://cht.sh
--
-- @param prams API string got https://cht.sh
--
-- @return API response
--
M.chtsh = function(params)
  local buffer = vim.t.doc_window_buffer
  if buffer and vim.api.nvim_buf_is_valid(buffer) then
    vim.api.nvim_buf_delete(buffer, {})
  end
  vim.cmd('split term://chtsh.sh ' .. params)
  vim.t.doc_window_buffer = vim.api.nvim_get_current_buf()
end

--
-- Go to last position in file buffer
--
M.goto_last_position = function()
  if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
    vim.cmd("normal! g'\"")
  end
end

--
-- Automatically write buffer after switch form insert to normal mode
-- Won't run for excluded buffers like nofile, trminal, gitcommit
--
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

--
-- Helper to set filetype and syntax.
--
-- @param ft Filetype
-- @param syn Syntax
-- @param matcher Optional table parameter. Will look if each matcher is in buffer content and set filetype and syntax if true.
--
M.set_filetype = function(ft, syn, matcher)
  local buffer = vim.api.nvim_get_current_buf()
  local doset = true
  for _,m in ipairs(matcher) do
    doset = vim.filetype.match({ buf = buffer, contents = { m } })
  end
  if doset then
    vim.bo.filetype = ft
    vim.bo.syntax = syn
  end
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
-- Run terminal command.
-- Will keep only single buffer per tab for all terminal commands closing previous buffer before launching new one.
--
-- @param params String of terminal command to run
--
-- @return open terminal window with params command output
--
M.run_term_cmd = function(params)
  vim.g.last_terminal_test = params
  if params == nil or params == '' then
    print('Missing terminal command to run')
  end

  if vim.t.terminal_window_buffer_number and vim.api.nvim_buf_is_valid(vim.t.terminal_window_buffer_number) then
    vim.api.nvim_buf_delete(vim.t.terminal_window_buffer_number, {})
  end

  vim.cmd('bo 15 split term://' .. params)
  vim.cmd('normal G')

  vim.t.terminal_window_buffer_number = vim.api.nvim_get_current_buf()
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

return M
