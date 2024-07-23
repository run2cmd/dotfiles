local startup = require('alpha')
local theme = require('alpha.themes.startify')
local mapkey = vim.keymap.set

theme.section.header.val = {
  [[ ______  _     _  ______ _____      __    _ _______  ______  _   _  _____ _______ ]],
  [[ |_____] |     | |  ____   |        | \\  | |______ |     |  \\  /    |   |  |  | ]],
  [[ |_____] |_____| |_____| __|__      |  \\_| |______ |_____|   \\/   __|__ |  |  | ]],
  [[                                                                                  ]],
}

theme.section.mru_cwd.val = { { type = 'padding', val = 0 } }
theme.nvim_web_devicons.enabled = false

startup.setup(theme.config)

mapkey('n', '<leader>L', ':bufdo %bd | Alpha<CR>:LspRestart<CR>')
mapkey('n', '<leader>to', ':tabnew<Bar>Alpha<CR>')
