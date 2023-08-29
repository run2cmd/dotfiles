--
-- Custom Auto commands
--
local helpers = require('run2cmd.helper-functions')

local autocmds = {
  doc_generation = {
    -- Update Helptags on start
    { event = { 'VimEnter' }, opts = { command = 'helptags ALL' } },
  },
  disable_bell = {
    -- Disable blink and bell
    { event = { 'GUIEnter' }, opts = { pattern = '*', command = 'set visualbell t_vb=' } },
  },
  set_title = {
    -- Set Title string for Tabs
    {
      event = { 'BufFilePre', 'BufEnter', 'BufWinEnter', 'DirChanged' },
      opts = { pattern = { '*', '!qf' }, command = 'let &titlestring = " " . getcwd()' },
    },
  },
  quickfix_window = {
    -- Make qf window size 10
    { event = { 'QuickFixCmdPost' }, opts = { pattern = '[^l]*', command = 'copen 10' } },
    { event = { 'QuickFixCmdPost' }, opts = { pattern = 'l*', command = 'lopen 10' } },
    -- Always move to last line in qf window
    { event = { 'FileType' }, opts = { pattern = 'qf', command = 'wincmd J' } },
    -- Close hidden buffers for Netrw
    { event = { 'FileType' }, opts = { pattern = 'netrw', command = 'setlocal bufhidden=wipe' } },
  },
  autosave = {
    {
      event = { 'InsertLeave' },
      opts = { pattern = '*', command = "lua require('run2cmd.helper-functions').autosave()" },
    },
  },
  filetypes = {
    { event = { 'FileType' }, opts = { pattern = 'markdown', command = 'setlocal spell' } },
    { event = { 'FileType' }, opts = { pattern = 'Terminal', command = 'setlocal nowrap' } },
    -- Restore colen keyword for easier jump to definition
    { event = { 'Filetype' }, opts = { pattern = 'puppet', command = 'setlocal iskeyword+=:' } },
  },
}
helpers.create_autocmds(autocmds)
