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

-- Detect proper gradle for project
local function gradle_bin()
  local binary = 'gradle'
  if helpers.file_exists('./gradlew') then
    binary = './gradlew'
  end
  return binary
end

--
-- Project Tests
--
local test_tbl = {
  projects = {
    maven = {
      marker = 'pom.xml',
      command = 'mvn clean install'
    },
    nodejs = {
      marker = 'package.json',
      command = 'yarn install & yarn build:prod'
    },
    puppet = {
      marker = 'manifests/init.pp',
      command = 'rake parallel_spec', 'rake beaker',
    },
    ansible = {
      marker = '.ansible-lint',
      command = 'ansible-lint %'
    },
    icha = {
      marker = 'Puppetfile',
      command = 'ichatest.sh'
    },
    gradle = {
      marker = 'build.gradle',
      command = gradle_bin() .. ' clean build --info'
    }
  },
  file_types = {
    groovy = 'groovy %',
    ruby = 'ruby %',
    rspec = 'BEAKER_destroy=no rspec %',
    plantuml = 'plantuml -tsvg -o ' .. vim.env.HOME .. '/.config/nvim/tmp %',
    python = 'python %',
    puppet = 'puppet apply --noop %',
    sh = 'bash %',
    xml = 'mvn clean install -f %',
    lua = 'lua %',
    groovy_test = gradle_bin() .. ' clean test --tests %:t:r --info'
  }
}

local function run_file()
  local filetype = vim.bo.filetype
  local test_cmd = test_tbl.file_types[filetype]
  helpers.run_term_cmd(test_cmd)
end

local function run_project()
  local project_marks = test_tbl.projects
  local test_cmd

  for _, v in pairs(project_marks) do
    if helpers.file_exists(v.marker) then
      test_cmd = v.command
      break
    end
  end

  helpers.run_term_cmd(test_cmd)
end

local function run_last()
  helpers.run_term_cmd(vim.g.last_terminal_test)
end

-- Easy mappings for for running tests. Got used to vim-dispatch in past so use them.
mapkey('n', '`f', run_file)
mapkey('n', '`t', run_project)
mapkey('n', '`l', run_last)
mapkey('n', '<leader>e', ':lua /FAILED\\|ERROR\\|Error\\|Failed<cr>')

local autocmds = {
  filetypes = {
    -- Detect yaml.ansible for Ansible LS support
    {
      event = { 'BufNewFile' , 'BufReadPost', 'BufEnter', 'BufWinEnter' },
      opts = { pattern = '*.yaml,*.yml', command = 'lua require("run2cmd.helper-functions").set_filetype("yaml.ansible", "yaml.ansible", { "- hosts:", "- name:" })' }
    },
    -- Detect ruby rspec file
    {
      event = { 'BufNewFile' , 'BufReadPost', 'BufEnter', 'BufWinEnter' },
      opts = { pattern = '*_spec.rb', command = 'lua require("run2cmd.helper-functions").set_filetype("rspec", "ruby", {})' }
    },
    -- Detect groovy test
    {
      event = { 'BufNewFile' , 'BufReadPost', 'BufEnter', 'BufWinEnter' },
      opts = { pattern = '*Test.groovy', command = 'lua require("run2cmd.helper-functions").set_filetype("groovy_test", "groovy", {})' }
    },
    -- Detect gradle file
    {
      event = { 'BufNewFile' , 'BufReadPost', 'BufEnter', 'BufWinEnter' },
      opts = { pattern = '*.gradle', command = 'lua require("run2cmd.helper-functions").set_filetype("gradle", "groovy", {})' }
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
  }
}
helpers.create_autocmds(autocmds)

-- Groovy formatting.
vim.api.nvim_create_user_command('GroovyFormat', ':lua require("run2cmd.helper-functions").run_term_cmd(\'npm-groovy-lint -r ~/.codenarc.groovy --noserver --format --nolintafter --files \\"**/\'.expand(\'%\').\'\\"', {})
