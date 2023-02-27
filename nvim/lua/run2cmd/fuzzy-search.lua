local helper = require('run2cmd.helper-functions')
local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config')
local builtin = require('telescope.builtin')
local mapkey = vim.keymap.set

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
        map('i', '<cr>', helper.telescope.open_project)
        map('n', '<cr>', helper.telescope.open_project)
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
          ['<c-t>'] = helper.telescope.open_float,
        },
      },
    },
    buffers = {
      hidden = true,
      previewer = false,
      mappings = {
        i = {
          ['<c-t>'] = helper.telescope.open_float,
        },
      },
    },
  },
})

-- Register support
mapkey('n', '<leader>p', builtin.registers)

-- Move around projects
mapkey('n', '<C-p>', builtin.find_files)
mapkey('n', '<C-h>', builtin.buffers)
mapkey('n', '<C-k>', find_projects)
mapkey('n', '<C-s>', ":lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<cr>")

-- Search text in project
mapkey('n', '<leader>sw', builtin.grep_string)
mapkey('n', '<leader>sl', builtin.live_grep)
mapkey('n', '<leader>sb', builtin.current_buffer_fuzzy_find)
