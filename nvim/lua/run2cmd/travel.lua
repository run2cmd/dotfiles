local helpers = require('run2cmd.helper-functions')
local mapkey = vim.keymap.set

local travel_marks = {
  puppet = {
    {
      path_include = 'manifests',
      replace = {
        { pattern = '%.pp', set_to = '_spec.rb' },
        { pattern = 'manifests', set_to = 'spec/classes' }
      }
    },
    {
      path_include = 'manifests',
      replace = {
        { pattern = '%.pp', set_to = '_spec.rb' },
        { pattern = 'manifests', set_to = 'spec/defines' }
      }
    }
  },
  groovy = {
    {
      path_include = 'src/main',
      replace = {
        { pattern = '%.groovy', set_to = 'Test.groovy' },
        { pattern = 'src/main', set_to = 'src/test' }
      }
    },
    {
      path_include = 'src/test',
      replace = {
        { pattern = 'Test%.groovy', set_to = '.groovy' },
        { path = 'src/test', set_to = 'src/main' }
      }
    }
  },
  ruby = {
    {
      path_include = 'spec/classes',
      replace = {
        { pattern = '_spec%.rb', set_to = '.pp' },
        { pattern = 'spec/classes', set_to = 'manifests' }
      }
    },
    {
      path_include = 'spec/defines',
      replace = {
        { pattern = '_spec%.rb', set_to = '.pp' },
        { pattern = 'spec/defines', set_to = 'manifests' }
      }
    }
  }
}

local function travel()
  local mark = travel_marks[vim.bo.filetype]
  if not mark then
    return
  end

  local path = vim.api.nvim_buf_get_name(0)
  local altpath = path

  for _, mark_item in ipairs(mark) do
    if string.match(path, mark_item.path_include) then
      for _, rule in ipairs(mark_item.replace) do
        altpath = string.gsub(altpath, rule.pattern, rule.set_to)
      end
      if helpers.file_exists(altpath) and not string.match(path, altpath) then
        vim.cmd(':e ' .. altpath)
        break
      end
    end
  end
end

mapkey('n', '<leader>tt', travel)
