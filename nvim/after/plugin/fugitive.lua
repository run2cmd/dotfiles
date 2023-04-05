local mapkey = vim.keymap.set

-- Jump to Git conflicts
mapkey('n', '<leader>ge', ':Ggrep "^<<<<<"<CR>')

-- Easy Git
-- Some mappings are done with Telescope. See telescope.lua.
mapkey('n', '<leader>gg', ':Git<cr>')
mapkey('n', '<leader>gf', ':Git pull<cr>')
mapkey('n', '<leader>gp', ':Git push<cr>')
mapkey('n', '<leader>g!p', ':Git push -f<cr>')
mapkey('n', '<leader>gw', ':Git blame<cr>')
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
