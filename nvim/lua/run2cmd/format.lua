--
-- Text format
--
-- See `:help fo-table` for formatoptions details
vim.o.formatoptions = vim.o.formatoptions .. 'jnM'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.joinspaces = false

-- Enable Neoformat puppet-lint support
vim.g.neoformat_puppet_puppetlint = {
  exe = 'puppet-lint',
  args = { '--fix', '--no-autoloader_layout-check' },
  ['replace'] = 1,
}
vim.g.neoformat_enabled_puppet = { 'puppetlint' }

-- Lua stylua formatter support
vim.g.neoformat_lua_stylua = {
  exe = 'stylua',
  args = { '-s' },
  ['replace'] = 1,
}
vim.g.neoformat_enabled_lua = { 'stylua' }

-- Markdown prettier support
vim.g.neoformat_markdown_prettier = {
  exe = 'prettier',
  args = { '--stdin-fileptah' },
  ['replace'] = 1,
}
vim.g.neoformat_enabled_markdown = { 'prettier' }
