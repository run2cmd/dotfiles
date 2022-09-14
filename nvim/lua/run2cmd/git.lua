local gitsigns = require('gitsigns')
local gitdiff = require('diffview')
local mapkey = vim.keymap.set

gitsigns.setup({
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '!', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  }
})

gitdiff.setup({
  use_icons = false,
})

-- Jump to Git conflicts
mapkey('n', '<leader>ge', ':Ggrep "^<<<<<"<CR>')

-- Easy Git
-- Git branches and git log is done with telescope. See telescope.lua file.
mapkey('n', '<leader>gs', ':Git<cr>')
mapkey('n', '<leader>gf', ':Git pull<cr>')
mapkey('n', '<leader>gp', ':Git push<cr>')
mapkey('n', '<leader>gb', ':Git blame<cr>')
mapkey('n', '<leader>gl', ':Git log<cr>')
mapkey('n', '<leader>ga', ':Git add %<cr>')
mapkey('n', '<leader>gc', ':Git checkout ')
mapkey('n', '<leader>gdo', ':DiffviewOpen<cr>')
mapkey('n', '<leader>gdc', ':DiffviewClose<cr>')
mapkey('n', '<leader>gdr', ':DiffviewRefreash<cr>')
mapkey('n', '<leader>gv', ':Gvdiffsplit<cr>')
