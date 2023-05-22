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
    exclude = 'Puppetfile',
    setup = ruby_env .. '&& bundle install && bundle exec rake spec_prep',
    command = ruby_env .. '&& bundle exec rake spec',
    errors = 'Error',
  },
  groovy = {
    command = 'groovy %',
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
    -- Use ruby 2.4.10 with Puppet 5.5.22
    command = ruby_env .. ' 2.4.10 && puppet apply --noop %',
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

  for k, v in pairs(test_tbl) do
    local filepattern = v.pattern or k
    local filemark = v.rootfile or 'none'
    local exclude = v.exclude or 'none'

    if string.match(setter, filepattern) then
      data.cmd = v.command
      data.err = v.errors or 'FAILED'
    elseif helpers.file_exists(filemark) and not helpers.file_exists(exclude) then
      data.proj = v.command
      data.prep = v.setup or 'none'
      data.err = v.errors or 'FAILED'
    end
  end

  return data
end

-- Run current file test
local function run_file()
  local test_data = helpers.merge(find_test(vim.bo.filetype), find_test(vim.fn.expand('%:t')))
  vim.g.term_error_serach_string = test_data.err
  helpers.run_term_cmd(test_data.cmd)
end

-- Run project test
local function run_project()
  local test_data = find_test('project')
  vim.g.term_error_serach_string = test_data.err
  helpers.run_term_cmd(test_data.proj)
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
  vim.g.term_error_serach_string = test_data.err
  helpers.run_term_cmd(test_data.prep)
end

-- Easy mappings for for running tests. Got used to vim-dispatch in past so use them.
mapkey('n', '`f', run_file)
mapkey('n', '`t', run_project)
mapkey('n', '`l', run_last)
mapkey('n', '`s', run_setup)
mapkey('n', '`e', find_errors)

-- Groovy formatting.
vim.api.nvim_create_user_command('GroovyFormat', ":lua require(\"run2cmd.helper-functions\").run_term_cmd('npm-groovy-lint -r ~/.codenarc.groovy --noserver --format --nolintafter --files \\\"**/'.expand('%').'\\\"", {})
