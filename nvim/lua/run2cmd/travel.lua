local helpers = require('run2cmd.helper-functions')
local mapkey = vim.keymap.set

local travel_marks = {
  puppet = {
    {
      path = 'manifests',
      pattern = '%.pp',
      setto = '_spec.rb',
    },
    {
      path = 'manifests',
      condition = '^class',
      setto = 'spec/classes',
    },
    {
      path = 'manifests',
      condition = '^define',
      setto = 'spec/defines',
    },
  },
  groovy = {
    {
      path = 'src/main',
      pattern = '%.groovy',
      setto = 'Test.groovy',
    },
    {
      path = 'src/main',
      setto = 'src/test',
    },
    {
      path = 'src/test',
      pattern = 'Test%.groovy',
      setto = '.groovy',
    },
    {
      path = 'src/test',
      setto = 'src/main',
    },
  },
  ruby = {
    {
      path = 'spec/classes',
      pattern = '_spec%.rb',
      setto = '.pp',
    },
    {
      path = 'spec/defines',
      pattern = '_spec%.rb',
      setto = '.pp',
    },
    {
      path = 'spec/classes',
      setto = 'manifests',
    },
    {
      path = 'spec/defines',
      setto = 'manifests',
    },
  },
}

local function travel()
  local mark = travel_marks[vim.bo.filetype]
  if not mark then
    return
  end

  local path = vim.api.nvim_buf_get_name(0)
  local altpath = path

  for _, v in ipairs(mark) do
    if not v.pattern then
      v.pattern = v.path
    end
    if string.match(path, v.path) then
      if v.condition then
        if helpers.buf_string_match(0, v.condition, 300) then
          altpath = string.gsub(altpath, v.pattern, v.setto)
        end
      else
        altpath = string.gsub(altpath, v.pattern, v.setto)
      end
    end
  end

  if helpers.file_exists(altpath) and not string.match(path, altpath) then
    vim.cmd(':e ' .. altpath)
  end
end

mapkey('n', '<leader>t', travel)
