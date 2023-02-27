local helper = require('run2cmd.helper-functions')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config')
local mapkey = vim.keymap.set

--
-- List notes and open file in new floating window
--
local function find_notes()
  pickers
    .new({}, {
      prompt_title = 'notes',
      finder = finders.new_oneshot_job({ 'fdfind', '--full-path', '.', '/home/pbugala/.notes' }),
      sorter = config.values.generic_sorter({}),
      layout_config = { anchor = 'NE', height = 15, width = 100 },
      attach_mappings = function(_, map)
        map('i', '<cr>', helper.telescope.open_buffer)
        map('n', '<cr>', helper.telescope.open_buffer)
        map('i', '<c-t>', helper.telescope.open_float)
        map('n', '<c-t>', helper.telescope.open_float)
        return true
      end,
    })
    :find()
end

-- Notes
vim.filetype.add({ extension = { note = 'note' } })
mapkey('n', '<C-n>', find_notes)
mapkey('n', '<leader>n', ":lua require('run2cmd.helper-functions').float_buffer(vim.g.last_notes_file, { width = 100, height = 30 })<cr>")
