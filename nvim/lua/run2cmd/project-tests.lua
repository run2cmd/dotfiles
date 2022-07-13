--
-- Sets test commands based on project type.
-- Async tests with terminal location. Make sure that terminal window gets replaced not create new one.
--
local function file_exists(path)
  local file = io.open(path, 'r')
  return file ~= nil and io.close(file)
end

function Run_terminal_cmd(params)
  vim.g.last_terminal_test = params
  if params == nil or params == '' then
    print('Missing terminal command to run')
  end

  if vim.t.terminal_window_buffer_number and vim.api.nvim_buf_is_valid(vim.t.terminal_window_buffer_number) then
    vim.api.nvim_buf_delete(vim.t.terminal_window_buffer_number, {})
  end

  vim.cmd('bo 15 split term://' .. params)
  vim.cmd('normal G')

  vim.t.terminal_window_buffer_number = vim.api.nvim_get_current_buf()
end

local function gradle_test()
  local binary = 'gradle'
  if file_exists('gradlew') then
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

function Project_discovery()
  local test_setup = { main = nil, alt = nil, file = nil }
  local project_setup = {}
  local file_setup = {}
  local filetype = vim.bo.filetype

  if file_exists('build.gradle') then
    project_setup = gradle_test()
  elseif file_exists('pom.xml') then
    project_setup = maven_test()
  elseif file_exists('package.json') then
    project_setup = nodejs_test()
  elseif file_exists('manifests/init.pp') then
    project_setup = puppet_test()
  elseif file_exists('.ansible-lint') then
    project_setup = ansible_test()
  elseif file_exists('Puppetfile')then
    project_setup = icha_test()
  end

  if filetype == 'ruby' then
    file_setup = ruby_run()
  elseif filetype == 'groovy' then
    file_setup = groovy_run()
  elseif filetype == 'plantuml' then
    file_setup = plantuml_run()
  elseif filetype == 'python' then
    file_setup = python_run()
  elseif filetype == 'sh' then
    file_setup = shell_run()
  elseif filetype == 'xml' then
    file_setup = xml_run()
  elseif filetype == 'lua' then
    file_setup = lua_run()
  elseif filetype == 'puppet' then
    file_setup = puppet_run()
  end

  for k,v in pairs(project_setup) do test_setup[k] = v end
  for k,v in pairs(file_setup) do test_setup[k] = v end

  return test_setup
end

vim.api.nvim_set_keymap('n', '`t', ':lua Run_terminal_cmd(Project_discovery().main)<cr>', {})
vim.api.nvim_set_keymap('n', '`a', ':lua Run_terminal_cmd(Project_discovery().alt)<cr>', {})
vim.api.nvim_set_keymap('n', '`f', ':lua Run_terminal_cmd(Project_discovery().file)<cr>', {})
vim.api.nvim_set_keymap('n', '`l', ':lua Run_terminal_cmd(vim.g.last_terminal_test)<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>e', ':lua /FAILED\\|ERROR\\|Error\\|Failed<cr>', {})
vim.api.nvim_create_user_command('GroovyFormat', ':lua Run_terminal_cmd(\'npm-groovy-lint -r ~/.codenarc.groovy --noserver --format --nolintafter --files \\"**/\'.expand(\'%\').\'\\"', {})
