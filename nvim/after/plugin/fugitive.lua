local mapkey = vim.keymap.set
local helpers = require('run2cmd.helper-functions')

-- Jump to Git conflicts
mapkey('n', '<leader>ge', ':Ggrep "^<<<<<"<CR>')

-- Easy Git
mapkey('n', '<leader>gg', ':Git<cr>')
mapkey('n', '<leader>gf', ':Git pull<cr>')
mapkey('n', '<leader>gp', ':Git push<cr>')
mapkey('n', '<leader>gw', ':Git blame<cr>')
mapkey('n', '<leader>gc', ':Git checkout ')
mapkey('n', '<leader>g-', ':Git checkout -<cr>')
mapkey('n', '<leader>gb', ':Git branch -a<cr>')
mapkey('n', '<leader>gm', ':Git merge ')
mapkey('n', '<leader>gss', ':Git stash<cr>')
mapkey('n', '<leader>gsp', ':Git stash pop<cr>')

-- diff
mapkey('n', '<leader>gv', ':Gvdiffsplit<cr>')
mapkey('n', '<leader>gdo', ':DiffviewOpen<cr>')
mapkey('n', '<leader>gdc', ':DiffviewClose<cr>')
mapkey('n', '<leader>gdr', ':DiffviewRefreash<cr>')

-- Git Log
mapkey('n', '<leader>gll', ':Git log --oneline --decorate=full<cr>')
mapkey('n', '<leader>glp', ':vert Git log --decorate=full -p --full-diff<cr>')
mapkey('n', '<leader>glf', ':vert Git log --decorate=full -p --follow -- %<cr>')

local autocmds = {
  git = {
    -- Go to insert mode when starting to edit messages
    { event = 'BufEnter', opts = { pattern = 'COMMIT_EDITMSG', command = 'startinsert' } },
    -- Pretty colors for git log
    { event = 'BufEnter', opts = { pattern = '*', command = "lua require('run2cmd.helper-functions').set_gitlog()" } },
  }
}
helpers.create_autocmds(autocmds)
