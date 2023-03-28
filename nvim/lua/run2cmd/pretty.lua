--
-- Lets look pretty :)
--
--
local opt = vim.o
local cmd = vim.cmd
local startup = require('alpha')
local theme = require('alpha.themes.startify')
local mapkey = vim.keymap.set
local colors = require('material.colors')

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

-- Colors
-- TODO:
--   * Groovy TS support.
local newcyan = '#56b6c2'
require('material').setup({
  contrast = {
    floating_windows = true,
  },
  plugins = {
    'gitsigns',
    'telescope',
    'nvim-cmp',
  },
  custom_highlights = {
    String = { fg = colors.main.darkgreen },
    ['@field.yaml'] = { fg = newcyan },
    ['@keyword.function.ruby'] = { fg = colors.main.darkred },
    PuppetName = { fg = newcyan },
    DiagnosticUnderlineError = { underline = false },
    DiagnosticUnderlineWarn = { underline = false },
    DiagnosticUnderlineInfo = { underline = false },
    DiagnosticUnderlineHint = { underline = false },
  },
})
vim.g.material_style = 'darker'
cmd('colorscheme material')

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
