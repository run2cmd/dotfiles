local mapkey = vim.keymap.set
local helpers = require('run2cmd.helper-functions')

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
    command = 'bundle exec rake spec',
  },
  puppet_proj = {
    rootfile = 'metadata.json',
    command = 'bundle exec rake parallel_spec',
  },
  tree_sitter = {
    rootfile = 'grammar.js',
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
    command = 'ruby %',
    alternative = {
      {
        pattern = '_spec.rb',
        command = 'bundle exec rspec %',
      }
    }
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

local function open_tmux()
  vim.cmd('silent !tmux split && tmux resize-pane -D 14')
end

local function tmux_id()
  local id = '0'
  local panes = vim.api.nvim_exec2(
    '!tmux list-panes -F "\\#D" ' ..
    '-f "\\#{m:bottom,\\#{?pane_at_bottom,bottom,}}" '..
    '-f "\\#{?\\#{m:nvim,\\#{pane_current_command}},0,1}"',
    { output = true }
  )
  for pane_id in string.gmatch(panes.output, "[^\r\n]+") do
    if string.match(pane_id, "^%%") then
      id = pane_id
    end
  end
  return id
end

local function tmux_cmd(id, cmd)
  vim.cmd(string.format('silent !tmux send -t \\%s -X cancel', id))
  vim.cmd(string.format('!tmux send -t \\%s "%s" ENTER', id, cmd))
end

local function run_test(cmd)
  if tmux_id() == '0' then
    open_tmux()
  end
  local id = tmux_id()
  tmux_cmd(id, 'cd ' .. vim.fn.getcwd())
  tmux_cmd(id, 'clear')
  tmux_cmd(id, cmd)
end

local function find_test()
  local data = {}
  for _, v in pairs(test_tbl) do
    local exclude = false
    for _, f in ipairs(v.exclude or {}) do
      if helpers.file_exists(f) then
        exclude = true
      end
    end
    if helpers.file_exists(v.rootfile or '-') and not exclude then
      data.proj = v.command
    end
  end
  return data
end

local function run_file()
  local data = test_tbl[vim.bo.filetype]
  if data then
    cmd = data.command
    for _, alt in ipairs(data.alternative) do
      if string.match(vim.fn.expand('%:t'), alt.pattern) then
        cmd = alt.command
      end
    end
    run_test(cmd)
  else
    print('[test] No file test pattern found.')
  end
end

local function run_project()
  local test_data = find_test()
  if test_data.proj then
    run_test(test_data.proj)
  else
    print('[test] Project not configured.')
  end
end

mapkey('n', '`f', run_file)
mapkey('n', '`t', run_project)
mapkey('n', '<leader>rk',
  function(_)
    run_test('ir10k')
  end
)
