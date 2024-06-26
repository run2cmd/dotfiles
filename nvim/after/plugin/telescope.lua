local helper = require('run2cmd.helper-functions')
local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config')
local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')
local mapkey = vim.keymap.set

local function get_selection(buffer)
  local table = action_state.get_selected_entry(buffer)
  local item = table[1]
  return item
end

local function open_float(buffer)
  local file_path = get_selection(buffer)
  actions.close(buffer)
  local opts = { width = 100, height = 30 }
  helper.float_buffer(file_path, opts)
end

local function find_projects()
  pickers
    .new({}, {
      prompt_title = 'Projects',
      finder = finders.new_oneshot_job({ 'fdfind', '--type=d', '--exact-depth=2', '--full-path', '.', '/code' }),
      sorter = config.values.generic_sorter({}),
      attach_mappings = function(_, map)
        map({ 'i', 'n' }, '<cr>', function (buffer)
          local dir_path = get_selection(buffer)
          actions.close(buffer)
          builtin.find_files({ cwd = string.gsub(dir_path, '/$', '') })
        end)
        return true
      end,
    })
    :find()
end

local function find_notes()
  pickers
    .new({}, {
      prompt_title = 'Notes',
      finder = finders.new_oneshot_job({ 'fdfind', '--full-path', '.', '/home/pbugala/.notes' }),
      sorter = config.values.generic_sorter({}),
      attach_mappings = function(_, map)
        map({ 'i', 'n' }, '<cr>', function(buffer)
          local file_path = get_selection(buffer)
          actions.close(buffer)
          vim.cmd.edit(file_path)
        end)
        return true
      end,
    })
    :find()
end

local function find_gh_prs()
  pickers
    .new({}, {
      prompt_title = 'GitHub Pull Requests',
      finder = finders.new_oneshot_job({ 'gh', 'pr', 'list' }),
      sorter = config.values.generic_sorter({}),
      attach_mappings = function(_, map)
        map({ 'i', 'n' }, '<cr>', function(buffer)
          local selection = get_selection(buffer):match('%d+')
          local pr_file = '/tmp/gh_pr.git'
          vim.cmd('silent !gh pr view ' .. selection .. ' &> ' .. pr_file)
          vim.cmd('silent !gh pr checks ' .. selection .. ' &>> ' .. pr_file)
          vim.cmd('silent !gh pr diff ' .. selection .. ' &>> ' .. pr_file)
          actions.close(buffer)
          local opts = { width = 220, height = 50, anchor = 'NW', col = 10, row = 2, border = 'double' }
          helper.float_buffer(pr_file, opts)
          vim.opt_local.filetype = 'git'
        end)
        return true
      end,
    })
    :find()
end

local function find_gh_runs()
  pickers
    .new({}, {
      prompt_title = 'GitHub Workflow Runs',
      finder = finders.new_oneshot_job({ 'gh', 'run', 'list' }),
      sorter = config.values.generic_sorter({}),
      attach_mappings = function(_, map)
        map({ 'i', 'n' }, '<cr>', function(buffer)
          local selection = get_selection(buffer):match('%d+%d+%d+%d+%d+')
          local runs_file = '/tmp/gh_runs.git'
          vim.cmd('silent !gh run view --log ' .. selection .. '| ansi2txt &> ' .. runs_file)
          actions.close(buffer)
          vim.cmd('vsplit')
          vim.cmd.edit(runs_file)
          vim.opt_local.list = false
          vim.cmd('/warning\\|error\\|failed')
        end)
        return true
      end,
    })
    :find()
end

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { '.git/', '.svn/' },
    mappings = {
      i = {
        ['<C-n>'] = actions.preview_scrolling_up,
        ['<C-p>'] = actions.preview_scrolling_down,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      previewer = false,
      mappings = {
        i = {
          ['<c-t>'] = open_float,
        },
      },
    },
    buffers = {
      hidden = true,
      previewer = false,
      mappings = {
        i = {
          ['<c-t>'] = open_float,
        },
      },
    },
    git_branches = {
      layout_strategy = 'vertical',
    },
    git_commits = {
      layout_strategy = 'vertical',
      wrap_results = true,
      git_command = { 'git', 'log', '--full-history', '--format=%h%Cred%d (%cr) (%ce) %s', '--', '.' },
    },
  },
})
require('telescope').load_extension('fzf')

mapkey('n', '<leader>p', builtin.registers)
mapkey('n', '<C-p>', builtin.find_files)
mapkey('n', '<C-h>', builtin.buffers)
mapkey('n', '<C-k>', find_projects)
mapkey('n', '<C-s>',
  function()
    require('telescope.builtin').find_files({hidden=true, no_ignore=true})
  end
)
mapkey('n', '<C-n>', find_notes)
mapkey('n', '<leader>sw', builtin.grep_string)
mapkey('n', '<leader>sl', builtin.live_grep)
mapkey('n', '<leader>sb', builtin.current_buffer_fuzzy_find)
mapkey('n', '<leader>sp', find_gh_prs)
mapkey('n', '<leader>sr', find_gh_runs)
