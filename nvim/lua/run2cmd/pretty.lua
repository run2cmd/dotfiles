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

-- I want a bit darker theme in zeprhy so do this:
-- Set in ~/.local/share/nvim/site/pack/packer/start/zephyr-nvim/lua/zephyr.lua:
--      bg = '#262626',
--      StatusLine = {fg=z.base8,bg=z.base4},
--      StatusLineNC = {fg=z.grey,bg=z.base4},
vim.cmd('colorscheme zephyr')
