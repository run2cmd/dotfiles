--
-- Lets look pretty :)
--
--
local startup = require('alpha')
local theme = require('alpha.themes.startify')
local mapkey = vim.keymap.set

-- Pretty greetings screen
theme.section.header.val = {
  [[ ______  _     _  ______ _____      __    _ _______  ______  _   _  _____ _______ ]],
  [[ |_____] |     | |  ____   |        | \\  | |______ |     |  \\  /    |   |  |  | ]],
  [[ |_____] |_____| |_____| __|__      |  \\_| |______ |_____|   \\/   __|__ |  |  | ]],
  [[                                                                                  ]],
}

theme.section.mru_cwd.val = { { type = 'padding', val = 0 } }
theme.nvim_web_devicons.enabled = false

theme.section.bottom_buttons.val = {
  theme.button('c', '~/dotfiles/nvim/init.lua', ':e ~/dotfiles/nvim/init.lua<cr>'),
}

startup.setup(theme.config)

-- Switch to greeteins screen and restart LSP server for better performance
mapkey('n', '<leader>l', ':bufdo %bd | Alpha<CR>:LspRestart<CR>')
mapkey('n', '<leader>to', ':tabnew<Bar>Alpha<CR>')
