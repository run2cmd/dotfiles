--
-- Tests plugin
--
local helpers = require('run2cmd.helper-functions')
local mapkey = vim.keymap.set
local ruby_env = 'source ~/.rvm/scripts/rvm && rvm use'

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
    command = 'gradlew clean build --info'
  },
  helm = {
    rootfile = 'helm',
    command = 'for i in $(ls helm) ;do mkdir -p templates_out/${i} && helm template helm/${i} --output-dir templates_out ;done',
  },
  ruby_proj = {
    rootfile =  'Gemfile',
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
    command = 'npm run lint && npm run test && npm run build'
  },
  groovy = {
    command = 'groovy %',
    ignore = 'Test.groovy'
  },
  groovy_test = {
    pattern = 'Test.groovy',
    command = 'gradlew clean test --tests %:t:r --info'
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
    for k, v in pairs(test_tbl) do
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
    helpers.run_term_cmd(test_data.cmd)
  else
    print('[test] No test command configured.')
  end
end

-- Run project test
local function run_project()
  local test_data = find_test('project')
  if test_data.proj then
    vim.g.term_error_serach_string = test_data.err
    helpers.run_term_cmd(test_data.proj)
  else
    print('[test] Project not configured.')
  end
end

-- Rerun last test
local function run_last()
  helpers.run_term_cmd(vim.g.last_terminal_test)
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
    helpers.run_term_cmd(test_data.prep)
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

-- Groovy formatting.
vim.api.nvim_create_user_command('GroovyFormat', ":lua require(\"run2cmd.helper-functions\").run_term_cmd('npm-groovy-lint -r ~/.codenarc.groovy --noserver --format --nolintafter --files \\\"**/'.expand('%').'\\\"", {})
