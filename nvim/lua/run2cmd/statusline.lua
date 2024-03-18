local helpers = require('run2cmd.helper-functions')

vim.o.cmdheight = 2
vim.o.laststatus = 2

local function get_lsp_status()
  local status = 'no-lsp'
  if next(vim.lsp.get_clients()) then
    status = require('lsp-status').status()
  end
  return status
end

function Status_line()
  return table.concat({
    '[',
    helpers.cmd_output('test -d .git && git branch --show-current'),
    ']',
    '[',
    helpers.cmd_output('test -d .git && git describe --tags --always'),
    ']',
    ' %F',
    ' %y[%{&ff}]',
    '[%{strlen(&fenc)?&fenc:&enc}a]',
    ' %h%m%r%w',
    '[',
    get_lsp_status(),
    ']',
  })
end
vim.o.statusline = "%!luaeval('Status_line()')"
