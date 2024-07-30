local mapkey = vim.keymap.set

require('diffview').setup({
  use_icons = false,
})

mapkey('n', '<leader>gdo', ':DiffviewOpen ')
mapkey('n', '<leader>gdc', ':DiffviewClose<cr>')
mapkey('n', '<leader>gdr', ':DiffviewRefreash<cr>')
mapkey('n', '<leader>gdv', ':DiffviewOpen HEAD~1 -- %<cr>')
