local mapkey = vim.keymap.set

mapkey('n', '<leader>ge', ':Ggrep "^<<<<<"<CR>')

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

mapkey('n', '<leader>gv', ':Gvdiffsplit<cr>')
mapkey('n', '<leader>gdo', ':DiffviewOpen<cr>')
mapkey('n', '<leader>gdc', ':DiffviewClose<cr>')
mapkey('n', '<leader>gdr', ':DiffviewRefreash<cr>')

mapkey('n', '<leader>gll', ':Git log --pretty=format:"%h %an %ad%d %s" --date=short<cr><cmd>silent :ownsyntax gitlog<cr>')
mapkey('n', '<leader>glp', ':vert Git log --decorate=full -p --full-diff<cr>')
mapkey('n', '<leader>glf', ':vert Git log --decorate=full -p --follow -- %<cr>')
