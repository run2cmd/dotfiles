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
  helper.float_buffer(file_path)
end

local function find_projects()
  pickers
    .new({}, {
      prompt_title = 'Projects',
      finder = finders.new_oneshot_job({ 'fdfind', '--type=d', '--exact-depth=1', '--full-path', '.', '/code' }),
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

local function easy_registers()
  local reglist = {}
  local yank_reg = helper.yank_registers
  table.sort(yank_reg)
  for i,v in ipairs(yank_reg) do
    reglist[i] = i .. ": " .. vim.fn.getreg(v)
  end
  vim.ui.select(reglist, {
      prompt = 'Choose register',
  }, function(choice)
    if choice then
      local paste_text = string.gsub(choice, '[0-9]*: ', '')
      if string.match(paste_text, '\n$') then
        paste_text = string.gsub(paste_text, '\n$', '')
        vim.cmd('normal o')
      end
      vim.api.nvim_paste(paste_text, true ,-1)
    end
  end)
end

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { '.git/', '.svn/' },
    vimgrep_arguments = {
     'rg',
     '--color=never',
     '--no-heading',
     '--with-filename',
     '--line-number',
     '--column',
     '--smart-case',
     '--hidden',
    },
    mappings = {
      i = {
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
      wrap_results = true,
    },
    git_bcommits = {
      wrap_results = true,
    },
    git_commits = {
      wrap_results = true,
      git_command = { 'git', 'log', '--full-history', '--format=%h%Cred%d (%cr) (%ce) %s', '--', '.' },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown({
        layout_config = {
          width = 0.5,
          height = 0.7
        }
      })
    }
  }
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')

mapkey({'n', 'v'}, '<C-y>', easy_registers)
mapkey('n', '<C-p>', builtin.find_files)
mapkey('n', '<C-h>', builtin.buffers)
mapkey('n', '<C-k>', find_projects)
mapkey('n', '<C-s>',
  function()
    require('telescope.builtin').find_files({hidden=true, no_ignore=true})
  end
)
mapkey('n', '<C-n>', find_notes)
mapkey('n', '<leader>sl', builtin.live_grep)
