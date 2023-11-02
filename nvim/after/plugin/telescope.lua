local helper = require('run2cmd.helper-functions')
local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config')
local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')
local mapkey = vim.keymap.set

--
-- Get Telescope selection from picker list. Only single selection support
--
-- @param buffer Prompt buffer from telescope picker.
--
local function get_selection(buffer)
  local table = action_state.get_selected_entry(buffer)
  local path = table[1]
  return path
end

--
-- Open new telescope.find_files picker given selection as directory path.
--
-- @param buffer Prompt buffer from telescope picker.
--
local function open_project(buffer)
  local dir_path = get_selection(buffer)
  actions.close(buffer)
  builtin.find_files({ cwd = string.gsub(dir_path, '/$', '') })
end

--
-- Open Telescope selection in new float window and uses ESC for :q.
--
-- @param buffer Prompt buffer from telescope picker.
--
local function open_float(buffer)
  local file_path = get_selection(buffer)
  actions.close(buffer)
  local opts = { width = 100, height = 30 }
  helper.float_buffer(file_path, opts)
end

--
-- Open Telescope selection in current window
--
-- @param buffer Prompt buffer from telescope picker.
--
local function open_buffer(buffer)
  local file_path = get_selection(buffer)
  actions.close(buffer)
  vim.cmd.edit(file_path)
end

--
-- List all project directories and open new find_files() for chosen one.
-- This speeds up moving around projects.
--
local function find_projects()
  pickers
    .new({}, {
      prompt_title = 'projects',
      finder = finders.new_oneshot_job({ 'fdfind', '--type=d', '--exact-depth=2', '--full-path', '.', '/code' }),
      sorter = config.values.generic_sorter({}),
      attach_mappings = function(_, map)
        map('i', '<cr>', open_project)
        map('n', '<cr>', open_project)
        return true
      end,
    })
    :find()
end

--
-- Setup notes support with telescope
--
local function find_notes()
  pickers
    .new({}, {
      prompt_title = 'notes',
      finder = finders.new_oneshot_job({ 'fdfind', '--full-path', '.', '/home/pbugala/.notes' }),
      sorter = config.values.generic_sorter({}),
      attach_mappings = function(_, map)
        map('i', '<cr>', open_buffer)
        map('n', '<cr>', open_buffer)
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

-- Register support
mapkey('n', '<leader>p', builtin.registers)

-- Move around projects
mapkey('n', '<C-p>', builtin.find_files)
mapkey('n', '<C-h>', builtin.buffers)
mapkey('n', '<C-k>', find_projects)
mapkey('n', '<C-s>',
  function()
    require('telescope.builtin').find_files({hidden=true, no_ignore=true})
  end
)
mapkey('n', '<C-n>', find_notes)

-- Search text in project
mapkey('n', '<leader>sw', builtin.grep_string)
mapkey('n', '<leader>sl', builtin.live_grep)
mapkey('n', '<leader>sb', builtin.current_buffer_fuzzy_find)
