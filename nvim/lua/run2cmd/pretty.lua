--
-- Lets look pretty :)
--
vim.o.noerrorbells = 'visualbell'

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'

vim.o.list = true
vim.o.listchars = 'conceal:^,nbsp:+'
vim.o.linebreak = true

vim.o.scrolloff = 2
vim.o.sidescrolloff = 5

vim.cmd('colorscheme zephyr')

local post_colors = {
}
for group, conf in pairs(post_colors) do
  vim.api.nvim_set_hl(0, group, conf)
end
