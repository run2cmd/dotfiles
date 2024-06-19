local mapkey = vim.keymap.set

require('gitsigns').setup({
  signs = {
    add = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change = { hl = 'GitSignsChange', text = '!', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    untracked = { hl = 'GitSignsUntracked', text = '?', numhl = 'GitSignsUntrackedr', linehl = 'GitSignsUntrackedLn' },
  },
})

mapkey('n', ']c', ':Gitsigns next_hunk<CR>')
mapkey('n', '[c', ':Gitsigns prev_hunk<CR>')
mapkey('n', '<leader>gv', ':Gitsigns diffthis ')
mapkey('n', '<leader>gb', ':Gitsigns blame_line<cr>')
