local gitsigns = require('gitsigns')
local gitdiff = require('diffview')
local builtin = require('telescope.builtin')
local mapkey = vim.keymap.set

gitsigns.setup({
  signs = {
    add = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change = { hl = 'GitSignsChange', text = '!', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
})

gitdiff.setup({
  use_icons = false,
})

require('telescope').setup({
  pickers = {
    git_branches = {
      layout_strategy = 'vertical',
    },
    git_commits = {
      layout_strategy = 'vertical',
      wrap_results = true,
      git_command = { 'git', 'log', '--format=%h%Cred%d (%cr) (%ce) %s', '--', '.' },
    },
  },
})

-- Jump to Git conflicts
mapkey('n', '<leader>ge', ':Ggrep "^<<<<<"<CR>')

-- Easy Git
-- Some mappings are done with Telescope. See telescope.lua.
mapkey('n', '<leader>gg', ':Git<cr>')
mapkey('n', '<leader>gf', ':Git pull<cr>')
mapkey('n', '<leader>gp', ':Git push<cr>')
mapkey('n', '<leader>g-', ':Git checkout -<cr>')

-- commit
mapkey('n', '<leader>ga', ':Git add %<cr>')
mapkey('n', '<leader>gcm', ':Git commit | startinsert<cr>')
mapkey('n', '<leader>gca', ':Git commit --amend --no-edit<cr>')

-- stash
mapkey('n', '<leader>gss', ':Git stash<cr>')
mapkey('n', '<leader>gsp', ':Git stash pop<cr>')

-- diff
mapkey('n', '<leader>gv', ':Gvdiffsplit<cr>')
mapkey('n', '<leader>gdo', ':DiffviewOpen<cr>')
mapkey('n', '<leader>gdc', ':DiffviewClose<cr>')
mapkey('n', '<leader>gdr', ':DiffviewRefreash<cr>')

-- Log and branches
mapkey('n', '<leader>gl', builtin.git_commits)
mapkey('n', '<leader>gb', builtin.git_branches)
