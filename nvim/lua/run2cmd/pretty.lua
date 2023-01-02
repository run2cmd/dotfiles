--
-- Lets look pretty :)
--
local opt = vim.o
local cmd = vim.cmd

opt.noerrorbells = 'visualbell'

opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'

opt.list = true
opt.listchars = 'conceal:^,nbsp:+'
opt.linebreak = true

opt.scrolloff = 2
opt.sidescrolloff = 5

vim.g.matchup_matchparen_offscreen = { method = 'popup' }

require('onedark').setup {
  style = 'darker',
}
cmd('colorscheme onedark')

-- Additional color overried
cmd('hi puppetName guifg=#4fa6ed')
cmd('hi puppetVariable guifg=#48b0bd')
