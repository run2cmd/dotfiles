--
-- Sets test commands based on project type.
--
local helpers = require('run2cmd.helper-functions')
local editorconfig = require('editorconfig')
local mapkey = vim.keymap.set

-- Project work space
vim.g.rooter_silent_chdir = 1
vim.g.rooter_patterns = { '!^fixtures', '.git', '.svn', '.rooter' }
vim.g.rooter_change_directory_for_non_project_files = 'current'
vim.g.startify_change_to_dir = 0
vim.g.EditorConfig_exclude_patterns = { 'fugitive://.\\*', 'scp://.\\*' }

-- Tags support
vim.g.gutentags_file_list_command = 'fdfind --type f . spec/fixtures/modules .'
vim.g.gutentags_cache_dir = vim.env.HOME .. '/.config/nvim/tags'

-- Ensure support max_line_length == off
editorconfig.properties.max_line_length = function(bufnr, val, opts)
  if opts.max_line_length then
    if opts.max_line_length == 'off' then
      vim.bo[bufnr].textwidth = 0
    else
      vim.bo[bufnr].textwidth = tonumber(val)
    end
  end
end

--
-- Setup some environment variables based on project type.
--
local function gradle_setenv()
  local binary = './gradlew'
  if not helpers.file_exists('./gradlew') then
    binary = 'gradle'
  end
  vim.env.NVIM_GRADLE_BIN = binary
end

local function project_env_setup()
  if helpers.file_exists('build.gradle') then gradle_setenv() end
end

local ruby_env = 'source ~/.rvm/scripts/rvm && rvm use'

--
-- Project Tests
--
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
    ruby = {
      marker = 'Gemfile',
      command = ruby_env .. '&& bundle exec rake spec',
      errors = 'Error'
    },
    ansible = {
      marker = '.ansible-lint',
      command = 'ansible-lint %',
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
    }
  },
  file_types = {
    groovy = {
      command = 'groovy %',
      alternatives = {
        {
          filename_contain = 'Test.groovy',
          command = '$NVIM_GRADLE_BIN clean test --tests %:t:r --info',
        },
      }
    },
    ruby = {
      command = ruby_env .. '&& ruby %',
      alternatives = {
        {
          filename_contain = '_spec.rb',
          command = ruby_env .. '&& BEAKER_destroy=no rspec %',
        }
      }
    },
    plantuml = {
      command = 'plantuml -tsvg -o ' .. vim.env.HOME .. '/.config/nvim/tmp %',
      alternatives = {},
    },
    python = {
      command = 'python %',
      alternatives = {},
    },
    puppet = {
      command = 'puppet apply --noop %',
      alternatives = {},
    },
    sh = {
      command = 'bash %',
      alternatives = {},
    },
    xml = {
      command = 'mvn clean install -f %',
      alternatives = {},
    },
    lua = {
      command = 'lua %',
      alternatives = {},
    },
  },
}

local function run_file()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand('%:t')
  local test_config = test_tbl.file_types[filetype]
  local test_cmd = test_config.command
  local error_str = test_config.errors or 'FAILED'

  for _, t in pairs(test_config.alternatives) do
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
      test_cmd = v.command
      error_str = v.errors or 'FAILED'
      break
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

-- Easy mappings for for running tests. Got used to vim-dispatch in past so use them.
mapkey('n', '`f', run_file)
mapkey('n', '`t', run_project)
mapkey('n', '`l', run_last)
mapkey('n', '`e', find_errors)

local autocmds = {
  filetypes = {
    -- Detect yaml.ansible for Ansible LS support
    {
      event = { 'BufNewFile' , 'BufReadPost', 'BufEnter', 'BufWinEnter' },
      opts = { pattern = '*.yaml,*.yml', command = 'lua require("run2cmd.helper-functions").set_filetype("yaml.ansible", "yaml.ansible", { "- hosts:", "- name:" })' }
    },
    { event = { 'FileType' }, opts = { pattern = 'markdown', command = 'setlocal spell' } },
    { event = { 'FileType' }, opts = { pattern = 'Terminal', command = 'setlocal nowrap' } }
  },
  -- Improve Vim buildin docs
  auto_docs = {
    { event = { 'FileType' }, opts = { pattern = 'python', command = 'set keywordprg=:term\\ ++shell\\ python3\\ -m\\ pydoc' } },
    { event = { 'FileType' }, opts = { pattern = 'puppet', command = 'set keywordprg=:term\\ ++shell\\ puppet\\ describe' } },
    { event = { 'FileType' }, opts = { pattern = 'ruby', command = 'set keywordprg=:term\\ ++shell\\ ri' } },
--    { event = { 'BufEnter' }, opts = { pattern = 'groovy', command = 'set keywordprg=:term\\ ++shell\\ $HOME/.vim/scripts/chtsh.bat groovy' } },
  },
  setup_project_environment = {
    { event = 'DirChanged', opts = { pattern = '*', callback = project_env_setup } }
  }
}
helpers.create_autocmds(autocmds)

-- Groovy formatting.
vim.api.nvim_create_user_command('GroovyFormat', ':lua require("run2cmd.helper-functions").run_term_cmd(\'npm-groovy-lint -r ~/.codenarc.groovy --noserver --format --nolintafter --files \\"**/\'.expand(\'%\').\'\\"', {})
