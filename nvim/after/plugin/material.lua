local colors = require('material.colors')
vim.g.material_style = 'darker'
require('material').setup({
  contrast = {
    floating_windows = true,
  },
  plugins = { 'gitsigns', 'telescope', 'nvim-cmp' },
  custom_highlights = {
    String = { fg = colors.main.darkgreen },
    ['@keyword.function.ruby'] = { fg = colors.main.darkred },
    DiagnosticUnderlineError = { underline = false },
    DiagnosticUnderlineWarn = { underline = false },
    DiagnosticUnderlineInfo = { underline = false },
    DiagnosticUnderlineHint = { underline = false },
  },
})
vim.cmd('colorscheme material')
