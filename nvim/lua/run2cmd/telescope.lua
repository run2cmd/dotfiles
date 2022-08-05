local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config')
local builtin = require('telescope.builtin')
local mapkey = vim.api.nvim_set_keymap

local M = {}

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { '.git/', '.svn/' },
    mappings = {
      i = {
        ['<C-n>'] = false,
        ['<C-p>'] = false,
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
  for k, v in pairs(dir_tbl) do
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
M.find_projects = function()
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
mapkey('n', '<C-p>', ":lua require('telescope.builtin').find_files()<cr>", {})
mapkey('n', '<C-h>', ":lua require('telescope.builtin').buffers()<cr>", {})
mapkey('n', '<C-k>', ":lua require('run2cmd.telescope').find_projects()<cr>", {})
mapkey('n', '<C-s>', ":lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<cr>", {})

return M
