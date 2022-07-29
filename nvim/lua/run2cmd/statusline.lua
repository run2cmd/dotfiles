--
-- Status line
--
vim.o.cmdheight = 2
vim.o.laststatus = 2

function Status_line()
  return table.concat {
    '[%{FugitiveHead(7)}]',
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
