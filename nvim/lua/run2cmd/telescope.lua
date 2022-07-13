local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config')
local builtin = require('telescope.builtin')

local M = {}

require('telescope').setup({
  defaults = {
    preview = false,
    file_ignore_patterns = { '.git/', '.svn/' },
    mappings = {
      i = {
        ['<C-n>'] = false,
        ['<C-p>'] = false,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      }
    }
  },
})

-- Get list of project files. It closes preview telescope window.
local function open_project(prompt_bufnr)
  local dir_path = ''
  local dir_tbl = action_state.get_selected_entry(prompt_bufnr)
  for k, v in pairs(dir_tbl) do
    dir_path = v
  end
  actions.close(prompt_bufnr)
  builtin.find_files({cwd = string.gsub(dir_path, '/$', '')
})
end

-- List all project directories and open new find_files() for chosen one.
-- This speeds up moving around projects.
M.find_projects = function()
  pickers.new({}, {
    prompt_title = 'projects',
    finder = finders.new_oneshot_job({'fdfind', '--type=d', '--maxdepth=2', '--min-depth=2', '--full-path', '.', '/code'}),
    sorter = config.values.generic_sorter({}),
    attach_mappings = function(_, map)
      map('i', '<cr>', open_project)
      map('n', '<cr>', open_project)
      return true
    end,
  }):find()
end

return M
