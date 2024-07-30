local mapkey = vim.keymap.set
local cmd = vim.api.nvim_create_user_command
local helper = require('run2cmd.helper-functions')
local status_file = '.git/nvim_git_status'

local function float_opts(...)
  return helper.merge({
    width = 120,
    height = 40,
    border = 'double',
    title_pos = 'center',
  }, ...)
end

local function git_cmd(command, ...)
  helper.float_terminal('git ' .. command, float_opts({ title = 'git ' .. command }, ...))
end

local function git_cmd_small(command, opts)
  git_cmd(command, { border = 'double', height = 7, row = 45 }, opts)
end

local function git_blame()
  local blame_commit_file = '.git/nvim_git_blame_commit'
  local bufname = vim.api.nvim_buf_get_name(0)
  local cur_pos = vim.api.nvim_win_get_cursor(0)
  local git_blame_str = helper.cmd_output('git blame -l -L' .. cur_pos[1] .. ',' .. cur_pos[1] .. ' ' .. bufname .. ' | ' .. "sed 's/ " .. cur_pos[1] .. ").*/)/'")
  helper.float_text({git_blame_str}, { width = 100, height = 1, border = 'single', row = cur_pos[1], col = cur_pos[2] + 6, relative = 'win' })
  mapkey('n', '<cr>', function()
    local commitid = vim.api.nvim_get_current_line():sub(1, 40):gsub("^^", '')
    vim.cmd(':q!')
    vim.cmd('silent !git --no-pager show ' .. commitid .. ' > ' .. blame_commit_file)
    helper.float_buffer(blame_commit_file, float_opts({ title = 'Git blame commit' }))
  end, { buffer = true })
end

local function git_file_info()
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
    '\'r\' to refresh status ' ..
    '" > ' .. status_file
  )
  vim.cmd('silent !echo "\\#\\# $(git config --get remote.origin.url)" >> ' .. status_file)
  vim.cmd('silent !git status --porcelain -b >> ' .. status_file)
end

local function git_enter_file()
  local file_info = git_file_info()
  vim.cmd(':q!')
  vim.cmd(':e ' .. file_info.path)
end

local function git_stage_toggle()
  local file_info = git_file_info()
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

local function git_commit()
  local commit_file = '.git/COMMIT_EDITMSG'
  helper.float_buffer(commit_file, float_opts({ width = 120, height = 2, row = 0, title = 'Git Commit Message' }))
  vim.cmd('silent !cat /dev/null > ' .. commit_file)
  mapkey('i', '<cr>', function()
    vim.cmd(':wq')
    git_cmd_small('commit -F ' .. commit_file, {})
    git_status_reload()
  end, { buffer = true })
  vim.cmd('startinsert')
end

local function git_amend()
  vim.cmd(':q!')
  git_cmd_small('commit --amend --no-edit', {})
end

local function git_file_diff()
  local diff_file = '.git/nvim_last_diff'
  local file_info = git_file_info()
  local file_path = file_info.path
  vim.cmd(':silent !git diff ' .. file_path .. ' > ' .. diff_file)
  vim.cmd(':silent !echo " " >> ' .. diff_file)
  vim.cmd(":!sed -i '/" .. string.gsub(file_path, '/', '\\/') .. '/r ' .. diff_file .. "' " .. status_file)
  vim.cmd(":e")
end

local function git_push()
  git_cmd_small('push --no-progress', {})
end

local function git_status()
  local map_opts = { buffer = true }
  if not helper.file_exists('.git') then
    print('Not in git repository')
    return
  end
  git_status_reload()
  helper.float_buffer(status_file, { height = 30, row = 6, border = 'double', title = 'Git Status' })
  vim.wo.number = true
  vim.wo.relativenumber = true
  mapkey('n', '.', git_add_all, map_opts)
  mapkey('n', '-', git_stage_toggle, map_opts)
  mapkey('n', '<cr>', git_enter_file, map_opts)
  mapkey('n', 'cc', git_commit, map_opts)
  mapkey('n', 'ca', git_amend, map_opts)
  mapkey('n', 'i', git_file_diff, map_opts)
  mapkey('n', 'p', git_push, map_opts)
  mapkey('n', 'r', git_status_reload, map_opts)
end

-- git log managed by telescope git_commits and git_bcommits
-- git diff done with diffview
mapkey('n', '<leader>gg', git_status)
mapkey('n', '<leader>gf', function() git_cmd_small('pull', {}) end)
mapkey('n', '<leader>g-', ':silent !git checkout -<cr>')
mapkey('n', '<leader>ge', ':grep "^<<<<<"<cr>')
mapkey('n', '<leader>gb', git_blame)
cmd('Git',
  function(params)
    git_cmd(params.args, {})
  end, { nargs = '*' }
)
