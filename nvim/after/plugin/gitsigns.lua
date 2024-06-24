local mapkey = vim.keymap.set

require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '!' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '?' },
  },
})

mapkey('n', ']c', ':Gitsigns next_hunk<CR>')
mapkey('n', '[c', ':Gitsigns prev_hunk<CR>')
mapkey('n', '<leader>gv', ':Gitsigns diffthis ')
mapkey('n', '<leader>gb', ':Gitsigns blame_line<cr>')
