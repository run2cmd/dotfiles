local helpers = require("run2cmd.helper-functions")

vim.o.cmdheight = 2
vim.o.laststatus = 2

local function get_lint_status()
  local counts = vim.diagnostic.count(0)
  local err = counts[vim.diagnostic.severity.ERROR] or 0
  local warn = counts[vim.diagnostic.severity.WARN] or 0
  local info = counts[vim.diagnostic.severity.INFO] or 0
  local hint = counts[vim.diagnostic.severity.HINT] or 0

  if err == 0 and warn == 0 and info == 0 and hint == 0 then
    return "OK"
  end

  local parts = {}
  if err > 0 then table.insert(parts, "E " .. err) end
  if warn > 0 then table.insert(parts, "W " .. warn) end
  if info > 0 then table.insert(parts, "I " .. info) end
  if hint > 0 then table.insert(parts, "H " .. hint) end
  return table.concat(parts, ", ")
end

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function() vim.cmd("redrawstatus") end,
})

function Status_line()
  return table.concat({
    "[",
    helpers.cmd_output("test -d .git && git branch --show-current"),
    "]",
    "[",
    helpers.cmd_output("test -d .git && git describe --tags --always"),
    "]",
    " %F",
    " %y[%{&ff}]",
    "[%{strlen(&fenc)?&fenc:&enc}a]",
    " %h%m%r%w",
    "[",
    get_lint_status(),
    "]",
  })
end

vim.o.statusline = "%!luaeval('Status_line()')"
