--
-- Status line
--
local helpers = require('run2cmd.helper-functions')

vim.o.cmdheight = 2
vim.o.laststatus = 2

function Status_line()
  return table.concat {
    '[', helpers.cmd_output('test -d .git && git branch --show-current'), ']',
    '[', helpers.cmd_output('test -d .git && git describe --tags --always'), ']',
    ' %F',
    ' %y[%{&ff}]',
    '[%{strlen(&fenc)?&fenc:&enc}a]',
    ' %h%m%r%w',
    '[',
    require('lsp-status').status(),
    ']'
  }
end
vim.o.statusline = "%!luaeval('Status_line()')"
