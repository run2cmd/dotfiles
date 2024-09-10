local helpers = require('run2cmd.helper-functions')

local autocmds = {
  doc_generation = {
    { event = { 'VimEnter' }, opts = { command = 'helptags ALL' } },
  },
  disable_bell = {
    { event = { 'GUIEnter' }, opts = { pattern = '*', command = 'set visualbell t_vb=' } },
  },
  quickfix_window = {
    { event = { 'QuickFixCmdPost' }, opts = { pattern = '[^l]*', command = 'copen 10' } },
    { event = { 'QuickFixCmdPost' }, opts = { pattern = 'l*', command = 'lopen 10' } },
    { event = { 'FileType' }, opts = { pattern = 'qf', command = 'wincmd J' } },
    { event = { 'FileType' }, opts = { pattern = 'netrw', command = 'setlocal bufhidden=wipe' } },
  },
  register_rule = {
    {
      event = { 'TextYankPost' },
      opts = {
        pattern = "*",
        callback = function()
          for idx,reg in ipairs(helpers.yank_registers) do
            if helpers.yank_registers[idx+1] then
              vim.cmd('let @' .. reg .. '=@' .. helpers.yank_registers[idx+1])
            end
          end
          vim.cmd('let @a=@"')
        end
      }
    }
  }
}
helpers.create_autocmds(autocmds)
