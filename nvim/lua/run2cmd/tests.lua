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

local function evaluate_cmd(cmd)
  local file_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local file_name = string.match(file_path, '/([^/]*)$')
  local file_no_ext = string.match(file_name, '[^.]*')
  local eval_cmd = cmd
  eval_cmd = string.gsub(eval_cmd, '%%:t:r', file_no_ext)
  eval_cmd = string.gsub(eval_cmd, '%%:t', file_name)
  eval_cmd = string.gsub(eval_cmd, '%%', file_path)
  return eval_cmd
end

local function run_test(cmd)
  helpers.open_tmux()
  local id = helpers.tmux_id()
  helpers.tmux_cmd(id, 'cd ' .. vim.fn.getcwd() .. ' && clear')
  helpers.tmux_cmd(id, cmd)
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
      data.proj = evaluate_cmd(v.command)
    end
  end
  return data
end

local function run_file()
  local data = test_tbl[vim.bo.filetype]
  if data then
    local cmd = data.command
    for _, alt in ipairs(data.alternative or {}) do
      if string.match(vim.fn.expand('%:t'), alt.pattern) then
        cmd = alt.command
      end
    end
    run_test(evaluate_cmd(cmd))
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
