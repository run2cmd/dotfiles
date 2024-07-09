local mapkey = vim.keymap.set
local cmd = vim.api.nvim_create_user_command
local helper = require('run2cmd.helper-functions')
local commit_file = '.git/COMMIT_EDITMSG'
local status_file = '.git/nvim_git_status'

local function git_commit()
  helper.float_buffer(commit_file, {
    border = 'double',
    height = 1,
    row = 3,
    title = 'Git Commit Message',
    title_pos = 'center',
  })
  vim.cmd('silent !cat /dev/null > ' .. commit_file)
  mapkey('i', '<cr>', '<Esc>:wq<cr>', { buffer = true })
  mapkey('n', '<Esc>', ':q!<cr>', { buffer = true })
  mapkey('i', '<C-c>', '<Esc>:q!<cr>', { buffer = true })
  vim.cmd('startinsert')
end

local function git_status_file_info()
  local file_line = vim.api.nvim_get_current_line()
  local file_path = string.sub(file_line, 4, -1)
  local file_status = string.sub(file_line, 1, 3)
  return { path = file_path, status = file_status }
end

local function git_status_reload()
  vim.cmd(
    'silent !echo "' ..
    '\\#\\# press: ' ..
    '\'i\' to view diff for file, ' ..
    '\'.\' to add all to commit, ' ..
    '\'-\' to toggle stage/unstage, ' ..
    '\'cc\' to commit, ' ..
    '\'ca\' to amend commit ' ..
    '\'p\' to push to remote ' ..
    '" > ' .. status_file
  )
  vim.cmd('silent !echo "\\#\\# $(git config --get remote.origin.url)" >> ' .. status_file)
  vim.cmd('silent !git status --porcelain -b >> ' .. status_file)
end

local function git_stage_toggle()
  local file_info = git_status_file_info()
  if string.match(file_info.status, '[A-Z]  ') then
    vim.cmd('silent !git reset ' .. file_info.path)
  else
    vim.cmd('silent !git add ' .. file_info.path)
  end
  git_status_reload()
end

local function git_add_all()
  vim.cmd('silent !git add .')
  git_status_reload()
end

local function git_enter_file()
  local file_info = git_status_file_info()
  vim.cmd(':q!')
  vim.cmd(':e ' .. file_info.path)
end

local function git_amend()
  vim.cmd(':q!')
  vim.cmd(':!git commit --amend --no-edit')
end

local function git_diff_file()
  local diff_file = '.git/nvim_last_diff'
  local file_info = git_status_file_info()
  local file_path = file_info.path
  vim.cmd(':silent !git diff ' .. file_path .. ' > ' .. diff_file )
  vim.cmd(':silent !echo " " >> ' .. diff_file)
  vim.cmd(":!sed -i '/" .. string.gsub(file_path, '/', '\\/') .. '/r ' .. diff_file .. "' " .. status_file)
  vim.cmd(":e")
end

local function git_status()
  local map_opts = { buffer = true }
  if not helper.file_exists('.git') then
    print('Not in git repository')
    return
  end
  git_status_reload()
  helper.float_buffer(status_file, {
    width = 100,
    height = 30,
    border = 'double',
    title = 'Git Status',
    title_pos = 'center',
  })
  vim.wo.number = true
  vim.wo.relativenumber = true
  mapkey('n', '.', git_add_all, map_opts)
  mapkey('n', '-', git_stage_toggle, map_opts)
  mapkey('n', '<cr>', git_enter_file, map_opts)
  mapkey('n', '<Esc>', ':q!<cr>', map_opts)
  mapkey('n', 'cc', git_commit, map_opts)
  mapkey('n', 'ca', git_amend, map_opts)
  mapkey('n', 'i', git_diff_file, map_opts)
  mapkey('n', 'p', ':!git push<cr>', map_opts)
end

local function git_cmd(command)
  helper.float_terminal('git ' .. command, {
    width = 120,
    height = 40,
    border = 'double',
    title = 'git ' .. command,
    title_pos = 'center',
  })
  mapkey('n', '<Esc>',
    function()
      vim.api.nvim_buf_delete(0, { force = true })
    end, { buffer = true }
  )
end

helper.create_autocmds({
  git_commit = {
    {
      event = { 'BufWritePost' },
      opts = {
        pattern = commit_file,
        callback = function()
          vim.cmd('!git commit -F ' .. commit_file)
          git_status_reload()
        end
      }
    }
  }
})

-- git log maps managed by telescope
-- git blame and file diff done with gitsigns
mapkey('n', '<leader>gg', git_status)
mapkey('n', '<leader>gf', ':!git pull<cr>')
mapkey('n', '<leader>g-', ':!git checkout -<cr>')
mapkey('n', '<leader>gdo', ':DiffviewOpen ')
mapkey('n', '<leader>gdc', ':DiffviewClose<cr>')
mapkey('n', '<leader>gdr', ':DiffviewRefreash<cr>')
mapkey('n', '<leader>ge', ':grep "^<<<<<"<cr>')
cmd('Git',
  function(params)
    git_cmd(params.args)
  end, { nargs = '*' }
)
