local helpers = require('run2cmd.helper-functions')

local autocmds = {
  doc_generation = {
    { event = { 'VimEnter' }, opts = { command = 'helptags ALL' } },
  },
  disable_bell = {
    { event = { 'GUIEnter' }, opts = { pattern = '*', command = 'set visualbell t_vb=' } },
  },
  set_title = {
    {
      event = { 'BufFilePre', 'BufEnter', 'BufWinEnter', 'DirChanged' },
      opts = { pattern = { '*', '!qf' }, command = 'let &titlestring = " " . getcwd()' },
    },
  },
  quickfix_window = {
    { event = { 'QuickFixCmdPost' }, opts = { pattern = '[^l]*', command = 'copen 10' } },
    { event = { 'QuickFixCmdPost' }, opts = { pattern = 'l*', command = 'lopen 10' } },
    { event = { 'FileType' }, opts = { pattern = 'qf', command = 'wincmd J' } },
    { event = { 'FileType' }, opts = { pattern = 'netrw', command = 'setlocal bufhidden=wipe' } },
  },
  filetypes = {
    { event = { 'FileType' }, opts = { pattern = 'markdown', command = 'setlocal spell' } },
    { event = { 'FileType' }, opts = { pattern = 'Terminal', command = 'setlocal nowrap' } },
    { event = { 'Filetype' }, opts = { pattern = 'puppet', command = 'setlocal iskeyword+=: commentstring=#\\ %s' } },
  },
}
helpers.create_autocmds(autocmds)

require('editorconfig').properties.end_of_line = function(_, val, opts)
  if not opts.end_of_line then
    return 'lf'
  else
    return val
  end
end
