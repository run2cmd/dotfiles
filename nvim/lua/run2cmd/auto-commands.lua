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
  syntax = {
    -- Always sync syntax
    { event = { 'BufEnter' }, opts = { pattern = '*', command = 'syntax sync fromstart' } },
  },
  set_title = {
    -- Set Title string for Tabs
    {
      event = { 'BufFilePre', 'BufEnter', 'BufWinEnter', 'DirChanged' },
      opts = { pattern = { '*', '!qf' }, command = 'let &titlestring = " " . getcwd()' },
    },
  },
  reopen_buffers = {
    -- Set cursor at last position when opening files
    {
      event = { 'BufReadPost' },
      opts = {
        pattern = '*',
        command = "lua require('run2cmd.helper-functions').goto_last_position()",
      },
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
      event = { 'CursorHold' },
      opts = { pattern = '*', command = "lua require('run2cmd.helper-functions').autosave()" },
    },
  },
  remove_trailing_line = {
    { event = { 'BufWrite' }, opts = { pattern = '*', command = ':%s/\\s\\+$//e' } },
  },
  notes = {
    { event = { 'Filetype' }, opts = { pattern = 'note', command = "let g:last_notes_file=expand('%:p')" } },
  },
  filetypes = {
    -- Detect yaml.ansible for Ansible LS support
    {
      event = { 'BufNewFile', 'BufReadPost', 'BufEnter', 'BufWinEnter' },
      opts = {
        pattern = '*.yaml,*.yml',
        command = 'lua require("run2cmd.helper-functions").set_filetype("yaml.ansible", "yaml.ansible", { "- hosts:", "- name:" })',
      },
    },
    { event = { 'FileType' }, opts = { pattern = 'markdown', command = 'setlocal spell' } },
    { event = { 'FileType' }, opts = { pattern = 'Terminal', command = 'setlocal nowrap' } },
  },
  -- Improve Vim buildin docs
  auto_docs = {
    {
      event = { 'FileType' },
      opts = { pattern = 'python', command = 'set keywordprg=:term\\ ++shell\\ python3\\ -m\\ pydoc' },
    },
    {
      event = { 'FileType' },
      opts = { pattern = 'puppet', command = 'set keywordprg=:term\\ ++shell\\ puppet\\ describe' },
    },
    { event = { 'FileType' }, opts = { pattern = 'ruby', command = 'set keywordprg=:term\\ ++shell\\ ri' } },
    -- Restore colen keyword for easier jump to definition
    { event = { 'Filetype' }, opts = { pattern = 'puppet', command = 'setlocal iskeyword+=:' } },
  },
}
helpers.create_autocmds(autocmds)
