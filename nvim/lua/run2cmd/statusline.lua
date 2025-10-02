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
    '[', helpers.cmd_output('test -d .git && git branch --show-current'), ']',
    '[', helpers.cmd_output('test -d .git && git describe --tags --always'), ']',
    ' %F',
    ' %y[%{&ff}]',
    '[%{strlen(&fenc)?&fenc:&enc}a]',
    ' %h%m%r%w',
    '[', get_lsp_status(), ']',
  })
end
vim.o.statusline = "%!luaeval('Status_line()')"

function Tab_Line()
  local tabline = ""
  for index = 1, vim.fn.tabpagenr('$') do
    if index == vim.fn.tabpagenr() then
      tabline = tabline .. '%#TabLineSel#'
    else
      tabline = tabline .. '%#TabLine#'
    end

    local tab_win_buf_id = vim.fn.tabpagebuflist(index)[1]
    local project_dir = helpers.find_root(tab_win_buf_id)
    local project_name = '[Scratch]'
    if project_dir ~= nil then
      project_name = vim.fn.fnamemodify(string.gsub(project_dir, '/$', ''), ":t")
    end
    tabline = tabline .. " " .. project_name .. " " .. '%#TabLine#'
  end

  return tabline
end
vim.o.tabline = "%!v:lua.Tab_Line()"
