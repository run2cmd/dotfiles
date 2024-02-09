--
-- Tests plugin
--
local helpers = require('run2cmd.helper-functions')
local mapkey = vim.keymap.set
local cmd = vim.api.nvim_create_user_command
local ruby_env = 'source ~/.rvm/scripts/rvm && rvm use'

--
-- Run terminal command.
-- Will keep only single buffer per tab for all terminal commands closing previous buffer before launching new one.
--
-- @param params String of terminal command to run
--
-- @return open terminal window with params command output
--
local function run_term_cmd(params)
  if params == nil or params == '' then
    print('Missing terminal command to run')
  end

  -- Support vim builtin expand
  local expand_match_string = '%%[^ ]*'
  local expand_string = string.match(params, expand_match_string)
  local command = string.gsub(params, expand_match_string, vim.fn.expand(expand_string))
  local pstring = command .. ' '
  local cwd = vim.fn.getcwd()

  -- Set per project last terminal test
  local expand_filepath = vim.fn.expand(pstring:gsub('(.*) (%%.*) (.*)', '%2'))
  local temp_last_table = vim.g.last_terminal_test
  temp_last_table[cwd] = pstring:gsub('(.*) (%%.*) (.*)', '%1 ' .. expand_filepath .. ' %3')
  vim.g.last_terminal_test = temp_last_table

  local term_buffer = vim.g.terminal_window_buffer_number[cwd]
  if term_buffer and vim.api.nvim_buf_is_valid(term_buffer) then
    vim.api.nvim_buf_delete(term_buffer, {})
  end

  local terminal_win_exists = false
  for _, v in pairs(vim.g.terminal_window_buffer_number) do
    if next(vim.fn.win_findbuf(v)) then
      terminal_win_exists = true
    end
  end

  if terminal_win_exists then
    vim.cmd('exe "normal \\<c-w>b"')
    vim.cmd('cd' .. cwd)
    vim.cmd('vsplit new')
  else
    vim.cmd('bo 15 split new')
  end
  vim.fn.termopen(command)
  vim.cmd('normal G')

  -- Set per project terminal buffer to use
  local temp_buf_table = vim.g.terminal_window_buffer_number
  temp_buf_table[cwd] = vim.api.nvim_get_current_buf()
  vim.g.terminal_window_buffer_number = temp_buf_table
end


local test_tbl = {
  maven = {
    rootfile = 'pom.xml',
    command = 'mvn clean install',
  },
  nodejs = {
    rootfile = 'package.json',
    exclude = { 'grammar.js' },
    command = 'yarn install & yarn build:prod',
  },
  icha = {
    rootfile = 'Puppetfile',
    command = 'ichatest',
  },
  gradle = {
    rootfile = 'build.gradle',
    command = 'gradlew clean build --info',
  },
  helm = {
    rootfile = 'helm',
    command = 'for i in $(ls helm) ;do mkdir -p templates_out/${i} && helm template helm/${i} --output-dir templates_out ;done',
  },
  ruby_proj = {
    rootfile = 'Gemfile',
    exclude = { 'Puppetfile', 'metadata.json' },
    setup = ruby_env .. '&& bundle install',
    command = ruby_env .. '&& bundle exec rake spec',
    errors = 'Error',
  },
  puppet_proj = {
    rootfile = 'metadata.json',
    setup = ruby_env .. '&& bundle install && bundle exec rake spec_clean && bundle exec rake spec_prep',
    command = ruby_env .. '&& bundle exec rake lint && bundle exec rake parallel_spec',
    errors = 'Error',
  },
  tree_sitter = {
    rootfile = 'grammar.js',
    setup = 'npm install',
    command = 'npm run lint && npm run build && npm run test',
  },
  groovy = {
    command = 'groovy %',
    ignore = 'Test.groovy',
  },
  groovy_test = {
    pattern = 'Test.groovy',
    command = 'gradlew clean test --tests %:t:r --info',
  },
  ruby = {
    command = ruby_env .. '&& ruby %',
  },
  ruby_spec = {
    pattern = '_spec.rb',
    command = ruby_env .. '&& BEAKER_destroy=no bundle exec rspec %',
  },
  plantuml = {
    command = 'plantuml -tsvg -o ' .. vim.env.HOME .. '/.config/nvim/tmp %',
  },
  python = {
    command = 'python %',
  },
  puppet = {
    command = 'puppet apply --noop %',
  },
  sh = {
    command = 'bash %',
  },
  xml = {
    command = 'mvn clean install -f %',
  },
  lua = {
    command = 'lua %',
  },
  go = {
    command = 'go run %',
  },
}

--
-- Find and parse test data.
--
-- @param setter filename pattern to compare against test_tbl.
--
-- @return { cmd = String, err = String, proj = String, prep = String }
--
local function find_test(setter)
  local data = {}

  if test_tbl[setter] and not string.match(test_tbl[setter]['ignore'] or '-', vim.fn.expand('%:t')) then
    data.cmd = test_tbl[setter]['command']
    data.err = test_tbl[setter]['error'] or 'FAILED'
  else
    for _, v in pairs(test_tbl) do
      local excludes = false
      for _, f in ipairs(v.exclude or {}) do
        if helpers.file_exists(f) then
          excludes = true
        end
      end
      if string.match(setter, v.pattern or '-') then
        data.cmd = v.command
        data.err = v.errors or 'FAILED'
      elseif helpers.file_exists(v.rootfile or '-') and not excludes then
        data.proj = v.command
        data.prep = v.setup
        data.err = v.errors or 'FAILED'
      end
    end
  end

  return data
end

-- Run current file test
local function run_file()
  local test_data = helpers.merge(find_test(vim.bo.filetype), find_test(vim.fn.expand('%:t')))
  if test_data.cmd then
    vim.g.term_error_serach_string = test_data.err
    run_term_cmd(test_data.cmd)
  else
    print('[test] No test command configured.')
  end
end

-- Run project test
local function run_project()
  local test_data = find_test('project')
  if test_data.proj then
    vim.g.term_error_serach_string = test_data.err
    run_term_cmd(test_data.proj)
  else
    print('[test] Project not configured.')
  end
end

-- Rerun last test
local function run_last()
  local cwd = vim.fn.getcwd()
  run_term_cmd(vim.g.last_terminal_test[cwd])
end

--- Find errors in test window
local function find_errors()
  vim.cmd('/' .. vim.g.term_error_serach_string)
end

-- Run project preparation steps
local function run_setup()
  local test_data = find_test('project')
  if test_data.prep then
    vim.g.term_error_serach_string = test_data.err
    run_term_cmd(test_data.prep)
  else
    print('[test] No setup steps configured for project.')
  end
end

-- Easy mappings for for running tests. Got used to vim-dispatch in past so use them.
mapkey('n', '`f', run_file)
mapkey('n', '`t', run_project)
mapkey('n', '`l', run_last)
mapkey('n', '`s', run_setup)
mapkey('n', '`e', find_errors)

-- Easy r10k support based on git branch
mapkey('n', '<leader>rk',
  function(_)
    run_term_cmd('ir10k')
  end
)

-- Terminal command support
cmd('Terminal',
  function(params)
    run_term_cmd(params.args)
  end,
  { nargs = '*' }
)
