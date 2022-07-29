--
-- Sets test commands based on project type.
--
local helpers = require('run2cmd.helper-functions')
local editorconfig = require('editorconfig')
local mapkey = vim.api.nvim_set_keymap

-- Project work space
vim.g.rooter_silent_chdir = 1
vim.g.rooter_patterns = { '!^fixtures', '.git', '.svn', '.rooter' }
vim.g.rooter_change_directory_for_non_project_files = 'current'
vim.g.startify_change_to_dir = 0
vim.g.EditorConfig_exclude_patterns = { 'fugitive://.\\*', 'scp://.\\*' }

-- Tags support
vim.g.gutentags_file_list_command = 'fdfind --type f . spec/fixtures/modules .'
vim.g.gutentags_cache_dir = vim.env.HOME .. '/.config/nvim/tags'
--vim.g.gutentags_project_root_finder = 'FindGutentagsRootDirectory'

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
-- Project Tests
--
local function gradle_test()
  local binary = 'gradle'
  if helpers.file_exists('gradlew') then
    binary = './gradlew'
  end
  return {
    main = binary .. ' clean build --info',
    alt = binary .. ' clean test --tests --info ' .. vim.fs.basename(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())):gsub('.groovy', '')
  }
end

local function maven_test()
  return { main = 'mvn clean install' }
end

local function nodejs_test()
  return { main = 'yarn install & yarn build:prod' }
end

local function puppet_test()
  return { main = 'rake parallel_spec', alt = 'rake beaker' }
end

local function ansible_test()
  return { main = 'ansible-lint %' }
end

local function icha_test()
  return { main = 'ichatest.sh' }
end

local function ruby_run()
  local testcmd = 'ruby %'
  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  if string.find(bufname, '_spec.rb') then
    testcmd = 'BEAKER_destroy=no rspec %'
  end
  return { file = testcmd }
end

local function groovy_run()
  return { file = 'groovy %' }
end

local function plantuml_run()
  local tempdir = vim.env.HOME .. '/.config/nvim/tmp'
  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  return { file = 'plantuml -tsvg -o ' .. tempdir .. ' ' .. bufname }
end

local function python_run()
  return { file = 'python %' }
end

local function puppet_run()
  return { file = 'puppet apply --noop %' }
end

local function shell_run()
  return { file = 'bash %' }
end

local function xml_run()
  return { file = 'mvn clean install -f %' }
end

local function lua_run()
  return { file = 'lua %' }
end

local project_marks = {
  { file = 'build.gradle', setup = gradle_test() },
  { file = 'pom.xml', setup = maven_test() },
  { file = 'package.json', setup = nodejs_test() },
  { file = 'manifests/init.pp', setup = puppet_test() },
  { file = '.ansible-lint', setup = ansible_test() },
  { file = 'Puppetfile', setup = icha_test() },
}

local file_types = {
  { file = 'puppet', setup = puppet_run() },
  { file = 'ruby', setup = ruby_run() },
  { file = 'groovy', setup = groovy_run() },
  { file = 'python', setup = python_run },
  { file = 'sh', setup = shell_run() },
  { file = 'lua', setup = lua_run() },
  { file = 'xml', setup = xml_run() },
  { file = 'plantuml', setup = plantuml_run() },
}

function Project_discovery()
  local test_setup = { main = nil, alt = nil, file = nil }
  local project_setup = {}
  local file_setup = {}
  local filetype = vim.bo.filetype

  for _, v in ipairs(project_marks) do
    if helpers.file_exists(v.file) then
      project_setup = v.setup
      break
    end
  end

  for _, v in ipairs(file_types) do
    if filetype == v.file then
      file_setup = v.setup
    end
  end

  for k,v in pairs(project_setup) do test_setup[k] = v end
  for k,v in pairs(file_setup) do test_setup[k] = v end

  return test_setup
end

local autocmds = {
  filetypes = {
    -- Start Groovy LSP only for groovy files. Do not care about Gradle or Jenkinsfile
    {
      event = { 'BufNewFile' , 'BufReadPost', 'BufEnter', 'BufWinEnter' },
      opts = { pattern = '*.groovy', command = ':LspStart' }
    },
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
  }
}
helpers.create_autocmds(autocmds)

-- Easy mappings for for running tests. Got used to vim-dispatch in past so use them.
mapkey('n', '`t', ':lua require("run2cmd.helper-functions").run_term_cmd(Project_discovery().main)<cr>', {})
mapkey('n', '`a', ':lua require("run2cmd.helper-functions").run_term_cmd(Project_discovery().alt)<cr>', {})
mapkey('n', '`f', ':lua require("run2cmd.helper-functions").run_term_cmd(Project_discovery().file)<cr>', {})
mapkey('n', '`l', ':lua require("run2cmd.helper-functions").run_term_cmd(vim.g.last_terminal_test)<cr>', {})
mapkey('n', '<leader>e', ':lua /FAILED\\|ERROR\\|Error\\|Failed<cr>', {})

-- Groovy formatting.
vim.api.nvim_create_user_command('GroovyFormat', ':lua require("run2cmd.helper-functions").run_term_cmd(\'npm-groovy-lint -r ~/.codenarc.groovy --noserver --format --nolintafter --files \\"**/\'.expand(\'%\').\'\\"', {})
