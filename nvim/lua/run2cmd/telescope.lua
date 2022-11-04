local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config')
local builtin = require('telescope.builtin')
local mapkey = vim.keymap.set

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { '.git/', '.svn/' },
    mappings = {
      i = {
        ['<C-n>'] = actions.preview_scrolling_up,
        ['<C-p>'] = actions.preview_scrolling_down,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      }
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      previewer = false,
    },
    buffers = {
      hidden = true,
      previewer = false,
    },
  }
})

--
-- Get list of project files. It closes preview telescope window.
--
-- @param prompt_bufnr It is automatically to current telescope window buffer
--
local function open_project(prompt_bufnr)
  local dir_path = ''
  local dir_tbl = action_state.get_selected_entry(prompt_bufnr)
  for _, v in pairs(dir_tbl) do
    dir_path = v
  end
  actions.close(prompt_bufnr)
  builtin.find_files({ cwd = string.gsub(dir_path, '/$', '')
  })
end

--
-- List all project directories and open new find_files() for chosen one.
-- This speeds up moving around projects.
--
local function find_projects()
  pickers.new({}, {
    prompt_title = 'projects',
    finder = finders.new_oneshot_job({ 'fdfind', '--type=d', '--maxdepth=2', '--min-depth=2', '--full-path', '.', '/code' }),
    sorter = config.values.generic_sorter({}),
    attach_mappings = function(_, map)
      map('i', '<cr>', open_project)
      map('n', '<cr>', open_project)
      return true
    end,
  }):find()
end

-- Move around projects
mapkey('n', '<C-p>', require('telescope.builtin').find_files)
mapkey('n', '<C-h>', require('telescope.builtin').buffers)
mapkey('n', '<C-k>', find_projects)
mapkey('n', '<C-s>', ":lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<cr>")

-- Git bindings
mapkey('n', '<leader>gl', require('telescope.builtin').git_commits)
mapkey('n', '<leader>gb', require('telescope.builtin').git_branches)
