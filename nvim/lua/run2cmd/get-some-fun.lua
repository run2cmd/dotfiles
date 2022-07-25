local startup = require('alpha')
local theme = require('alpha.themes.startify')

theme.section.header.val = {
  [[ ______  _     _  ______ _____      __    _ _______  ______  _   _  _____ _______ ]],
  [[ |_____] |     | |  ____   |        | \\  | |______ |     |  \\  /    |   |  |  | ]],
  [[ |_____] |_____| |_____| __|__      |  \\_| |______ |_____|   \\/   __|__ |  |  | ]],
  [[                                                                                  ]],
}

theme.section.mru_cwd.val = { { type = "padding", val = 0 } }
theme.nvim_web_devicons.enabled = false

theme.section.bottom_buttons.val = {
  theme.button('c', '~/dotfiles/nvim/init.lua', ':e ~/dotfiles/nvim/init.lua<cr>'),
  theme.button('b', '~/dotfiles/viebrc',':e ~/dotfiles/viebrc<cr>'),
  theme.button('h', '/etc/hosts', ':e /etc/hosts<cr>'),
  theme.button('n', '~/notes.md', ':e ~/notes.md<cr>')
}

startup.setup(theme.config)
