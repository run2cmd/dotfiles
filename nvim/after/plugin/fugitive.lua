local mapkey = vim.keymap.set
local helpers = require('run2cmd.helper-functions')

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

mapkey('n', '<leader>gll', ':Git log --pretty=format:"%h %an %ad%d %s" --date=short<cr>')
mapkey('n', '<leader>glp', ':vert Git log --decorate=full -p --full-diff<cr>')
mapkey('n', '<leader>glf', ':vert Git log --decorate=full -p --follow -- %<cr>')

local autocmds = {
  git = {
    { event = 'BufEnter', opts = { pattern = 'COMMIT_EDITMSG', command = 'startinsert' } },
    { event = 'BufEnter',
      opts = {
        pattern = '*',
        callback = function()
          local current_buf = vim.api.nvim_get_current_buf()
          if vim.api.nvim_get_option_value('filetype', {}) == 'git' then
            local content = vim.api.nvim_buf_get_lines(current_buf, 1, 6, false)
            local count = 0
            for _, c in ipairs(content) do
              local sub = string.sub(c, 1, 7)
              if not string.match(sub, ' ') then
                count = count + 1
              end
            end
            if count == 5 then
              vim.cmd('ownsyntax gitlog')
            end
          end
        end
      }
    }
  }
}

helpers.create_autocmds(autocmds)
