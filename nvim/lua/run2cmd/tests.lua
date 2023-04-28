--
-- Tests plugin
--
local helpers = require('run2cmd.helper-functions')
local mapkey = vim.keymap.set
local ruby_env = 'source ~/.rvm/scripts/rvm && rvm use'

local test_tbl = {
  projects = {
    maven = {
      marker = 'pom.xml',
      command = 'mvn clean install',
    },
    nodejs = {
      marker = 'package.json',
      command = 'yarn install & yarn build:prod',
    },
    icha = {
      marker = 'Puppetfile',
      command = 'ichatest.sh',
    },
    gradle = {
      marker = 'build.gradle',
      command = '$NVIM_GRADLE_BIN clean build --info',
    },
    helm = {
      marker = 'helm',
      command = 'for i in $(ls helm) ;do mkdir -p templates_out/${i} && helm template helm/${i} --output-dir templates_out ;done',
    },
    ruby = {
      marker = 'Gemfile',
      exclude = 'Puppetfile',
      setup = ruby_env .. '&& bundle install && bundle exec rake spec_prep',
      command = ruby_env .. '&& bundle exec rake spec',
      errors = 'Error',
    },
  },
  file_types = {
    groovy = {
      command = 'groovy %',
      alternatives = {
        {
          filename_contain = 'Test.groovy',
          command = '$NVIM_GRADLE_BIN clean test --tests %:t:r --info',
        },
      },
    },
    ruby = {
      command = ruby_env .. '&& ruby %',
      alternatives = {
        {
          filename_contain = '_spec.rb',
          command = ruby_env .. '&& BEAKER_destroy=no bundle exec rspec %',
        },
      },
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
  },
}

local function run_file()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%:t')
  local test_config = test_tbl.file_types[filetype]
  local test_cmd = test_config.command
  local error_str = test_config.errors or 'FAILED'
  local alts = test_config.alternatives or {}

  for _, t in pairs(alts) do
    if string.match(filename, t.filename_contain) then
      test_cmd = t.command
      error_str = t.errors or 'FAILED'
      break
    end
  end

  vim.g.term_error_serach_string = error_str
  helpers.run_term_cmd(test_cmd)
end

local function run_project()
  local project_marks = test_tbl.projects
  local error_str
  local test_cmd

  for _, v in pairs(project_marks) do
    if helpers.file_exists(v.marker) then
      local exclude = v.exclude or 'no_exclude_file_check'

      if not helpers.file_exists(exclude) then
        test_cmd = v.command
        error_str = v.errors or 'FAILED'
        break
      end
    end
  end

  vim.g.term_error_serach_string = error_str
  helpers.run_term_cmd(test_cmd)
end

local function run_last()
  helpers.run_term_cmd(vim.g.last_terminal_test)
end

local function find_errors()
  vim.cmd('/' .. vim.g.term_error_serach_string)
end

local function run_setup()
  local project_marks = test_tbl.projects
  local error_str
  local test_cmd

  for _, v in pairs(project_marks) do
    if helpers.file_exists(v.marker) then
      local exclude = v.exclude or 'no_exclude_file_check'

      if not helpers.file_exists(exclude) then
        test_cmd = v.setup or 'none'
        error_str = v.errors or 'FAILED'
        break
      end
    end
  end

  vim.g.term_error_serach_string = error_str
  if not(test_cmd == 'none') then
    helpers.run_term_cmd(test_cmd)
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
