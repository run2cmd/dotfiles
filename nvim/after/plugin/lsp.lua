local helpers = require('run2cmd.helper-functions')
local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')
local cmp = require('cmp')
local cmp_lsp = require('cmp_nvim_lsp')
local mapkey = vim.keymap.set

vim.diagnostic.config({
  virtual_text = false
})

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<c-k>'] = cmp.mapping.select_prev_item(),
    ['<c-j>'] = cmp.mapping.select_next_item(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    {
      name = 'buffer',
      keyword_lenght = 3,
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
  },
})

cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())

lsp_status.register_progress()
lsp_status.config({
  status_symbol = '',
  indicator_errors = 'E',
  indicator_warnings = 'W',
  indicator_info = 'I',
  indicator_hint = '?',
  indicator_ok = 'OK',
  select_symbol = false,
  show_filename = false,
})

vim.o.tagfunc = 'v:lua.vim.lsp.tagfunc'

local function config(_config)
  return vim.tbl_deep_extend('force', {
    capabilities = cmp_lsp.default_capabilities(vim.tbl_extend('keep', vim.lsp.protocol.make_client_capabilities(), lsp_status.capabilities)),
    on_attach = function(_, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      mapkey('n', 'K', vim.lsp.buf.hover, opts)
      mapkey('n', '<leader>qf', vim.diagnostic.setqflist, opts)
      mapkey('n', '<leader>bf', vim.lsp.buf.format, opts)
      mapkey('n', '<leader>br', vim.lsp.buf.rename, opts)
      mapkey('n', '[d', vim.diagnostic.goto_next, opts)
      mapkey('n', ']d', vim.diagnostic.goto_prev, opts)
    end,
  }, _config or {})
end

lspconfig.bashls.setup(config())
lspconfig.pylsp.setup(config({
  settings = {
    pylsp = {
      configurationSources = { 'flake8' },
      plugins = {
        autopep8 = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        yapf = { enabled = true },
        flake8 = {
          enabled = true,
          maxLineLength = 250,
          indentSize = 2,
        },
      },
    },
  },
}))
lspconfig.jsonls.setup(config())
lspconfig.vimls.setup(config())
lspconfig.dockerls.setup(config())
lspconfig.terraformls.setup(config())
lspconfig.marksman.setup(config())
lspconfig.lua_ls.setup(config({
  cmd = { 'luals.sh' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = {
          library = { vim.env.VIMRUNTIME },
        },
      },
    },
  },
}))
lspconfig.golangci_lint_ls.setup(config())
lspconfig.tsserver.setup(config())
lspconfig.ansiblels.setup(config({
  settings = {
    ansible = {
      ansible = {
        useFullyQualifiedCollectionNames = false,
      },
      python = {
        interpreterPath = 'pyenv',
      },
      validation = {
        lint = {
          path = 'exec',
          arguments = 'ansible-lint -c ~/.ansible-lint',
        },
      },
    },
  },
}))
lspconfig.helm_ls.setup(config())
lspconfig.yamlls.setup(config({
  settings = {
    yaml = {
      schemas = {
        ['schemas/conf/ansible.json'] = 'conf/ansible.yaml',
        ['schemas/conf/jenkins/endpoints.json'] = 'conf/jenkins/endpoints.yaml',
        ['schemas/conf/jenkins/settings.json'] = 'conf/jenkins/settings.yaml',
        ['schemas/conf/jenkins/config.json'] = 'conf/jenkins/**/config.yaml',
        ['schemas/conf/jenkins/components.json'] = 'conf/jenkins/**/components.yaml',
        ['schemas/conf/pullrequests.json'] = 'conf/jenkins/pullrequests.yaml',
        ['schemas/data/env/env_file.json'] = 'data/env/*.yaml',
        ['schemas/profiles.json'] = 'profiles/**/*.yaml',
        ['schemas/products.json'] = 'products/**/*.yaml',
      },
    },
  },
}))
lspconfig.solargraph.setup(config({
  cmd = { 'sgraph' },
}))
lspconfig.diagnosticls.setup(config({
  filetypes = { 'xml', 'eruby', 'lua', 'markdown', 'puppet', 'groovy', 'Jenkinsfile', 'yaml' },
  init_options = {
    linters = {
      mdl = {
        sourceName = 'mdl',
        command = 'mdl',
        args = { '-j' },
        parseJson = {
          line = 'line',
          message = '[mdl] ${rule} ${description}',
        },
      },
      yamllint = {
        sourceName = 'yamllint',
        command = 'yamllint',
        args = { '-f', 'parsable', '%filepath' },
        formatPattern = {
          [[^.*:(\d+):(\d+): \[(\w+)\] (.*)$]],
          {
            line = 1,
            column = 2,
            security = 3,
            message = { '[yamllint] ', 4 }
          }
        },
        securities = {
          warning = 'warning',
          error = 'error'
        }
      },
      xmllint = {
        sourceName = 'xmllint',
        command = 'xmllint',
        args = { '--noout', '-' },
        isStderr = true,
        formatLines = 1,
        formatPattern = {
          '^[^:]+:(\\d+):(.*)$',
          {
            line = 1,
            message = { '[xmllint]', 2 },
          },
        },
      },
      erb = {
        sourceName = 'erb',
        command = 'erbvalidate',
        args = { '%relativepath' },
        isStderr = true,
        formatLines = 1,
        formatPattern = {
          '^-:(\\d+):(.*)$',
          {
            line = 1,
            message = { '[erb]', 2 },
          },
        },
      },
      groovylint = {
        sourceName = 'groovylint',
        command = 'groovylint',
        args = { '%relativepath' },
        rootPatterns = { '.git' },
        formatLines = 1,
        formatPattern = {
          'Violation: Rule=(.*) P=(\\d+) Line=(\\d+) Msg=\\[(.*)\\] Src=',
          {
            security = 2,
            line = 3,
            message = { '[groovylint]', ' [', 1, '] ', 4 },
          },
        },
        securities = {
          ['1'] = 'error',
          ['2'] = 'warning',
          ['3'] = 'info',
        },
      },
      puppetlint = {
        sourceName = 'puppetlint',
        command = 'puppet-lint',
        args = { '%relativepath', '-c', vim.env.HOME .. '/.puppet-lint.rc', '--relative', '--log-format', '%{kind} %{line}:%{column} %{message}' },
        rootPatterns = { '.git' },
        formatLines = 1,
        formatPattern = {
          '(.*) (\\d+):(\\d+) (.*)',
          {
            security = 1,
            line = 2,
            column = 3,
            message = { '[puppetlint] ', 4 }
          },
        },
        securities = {
          error = 'error',
          warning = 'warning'
        }
      },
    },
    filetypes = {
      xml = 'xmllint',
      eruby = 'erb',
      markdown = 'mdl',
      groovy = 'groovylint',
      Jenkinsfile = 'groovylint',
      yaml = 'yamllint',
      puppet = 'puppetlint',
    },
    formatters = {
      stylua = {
        command = 'stylua',
        args = { '--color', 'Never', '-' },
        rootPatterns = { '.git' },
      },
      puppetlint = {
        command = 'puppet-lint',
        doesWriteToFile = true,
        args = { '-f', '%file' },
      },
    },
    formatFiletypes = {
      lua = 'stylua',
      puppet = 'puppetlint',
    },
  },
}))

local puppet_tags_file = vim.env.HOME .. '/.config/nvim/tags/puppet'
helpers.create_autocmds({
  puppet_lsp = {
    {
      event = { 'Filetype' },
      opts = {
        pattern = 'puppet',
        callback = function()
          vim.opt_local.tags = puppet_tags_file
        end,
      },
    },
  },
})
vim.api.nvim_create_user_command('PuppetTagsGenerate', function()
  vim.cmd('!mkdir -p ' .. vim.fs.dirname(puppet_tags_file))
  vim.cmd('!ctags -R -o ' .. puppet_tags_file .. ' --languages=PuppetManifest --exclude=fixtures /code')
end, {})

local function groovy_tags_file()
  return vim.env.HOME .. '/.config/nvim/tags/' .. vim.fs.basename(vim.uv.cwd()) .. '/groovy'
end
helpers.create_autocmds({
  groovy_lsp = {
    {
      event = { 'Filetype' },
      opts = {
        pattern = 'groovy',
        callback = function()
          vim.opt_local.tags = groovy_tags_file()
        end,
      },
    },
  },
})
vim.api.nvim_create_user_command('GroovyTagsGenerate', function()
  vim.cmd('!mkdir -p ' .. vim.fs.dirname(groovy_tags_file()))
  vim.cmd('!ctags -R -o ' .. groovy_tags_file() .. ' --languages=groovy ' .. vim.uv.cwd())
end, {})

-- vim.lsp.set_log_level('debug')
