local lsp = require('lsp-zero').preset({})
local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')
local cmp = require('cmp')
local mapkey = vim.keymap.set
local homedir = vim.env.HOME

-- Overwrite default tag jump to use LSP definitions and then fall back to tags
vim.o.tagfunc = 'v:lua.vim.lsp.tagfunc'

cmp.setup({
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
    { name = 'luasnip', keyword_lenght = 2 },
  },
})

-- Cmp Auto pairs integration
cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())

-- Setup lsp_status
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

lsp.on_attach(function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  mapkey('n', '<leader>vd', vim.diagnostic.open_float, opts)
  mapkey('n', '[d', vim.diagnostic.goto_next, opts)
  mapkey('n', ']d', vim.diagnostic.goto_prev, opts)
  mapkey('n', 'K', vim.lsp.buf.hover, opts)
  mapkey('n', '<leader>bf', vim.lsp.buf.format, opts)
  mapkey('n', '<leader>ba', vim.lsp.buf.code_action, opts)
  mapkey('n', '<leader>br', vim.lsp.buf.rename, opts)
  mapkey('n', '<leader>bl', vim.lsp.buf.references, opts)
  --mapkey('n', '<leader>gd', vim.lsp.buf.definition, opts)
  --mapkey('v', '<leader>gd', vim.lsp.buf.definition, opts)
end)

lsp.ensure_installed({
  'bashls',
  'jedi_language_server',
  'solargraph',
  'puppet',
  'groovyls',
  'yamlls',
  'jsonls',
  'ansiblels',
  'vimls',
  'dockerls',
  'terraformls',
  'lua_ls',
})

lspconfig.yamlls.setup({
  settings = {
    yaml = {
      -- Schemas to support ICHA
      schemas = {
        ['schemas/conf/ansible.json'] = 'conf/ansible.yaml',
        ['schemas/conf/jenkins/endpoints.json'] = 'conf/jenkins/endpoints.yaml',
        ['schemas/conf/jenkins/settings.json'] = 'conf/jenkins/settings.yaml',
        ['schemas/conf/jenkins/acgs/components.json'] = 'conf/jenkins/acgs/components.yaml',
        ['schemas/conf/jenkins/acgs/config.json'] = 'conf/jenkins/acgs/config.yaml',
        ['schemas/conf/jenkins/acgs/streams.json'] = 'conf/jenkins/acgs/streams.yaml',
        ['schemas/conf/jenkins/aops/components.json'] = 'conf/jenkins/aops/components.yaml',
        ['schemas/conf/jenkins/aops/config.json'] = 'conf/jenkins/aops/config.yaml',
        ['schemas/conf/jenkins/aops/streams.json'] = 'conf/jenkins/aops/streams.yaml',
        ['schemas/conf/jenkins/arbus/components.json'] = 'conf/jenkins/arbus/components.yaml',
        ['schemas/conf/jenkins/arbus/config.json'] = 'conf/jenkins/arbus/config.yaml',
        ['schemas/conf/jenkins/boa/components.json'] = 'conf/jenkins/boa/components.yaml',
        ['schemas/conf/jenkins/boa/config.json'] = 'conf/jenkins/boa/config.yaml',
        ['schemas/conf/jenkins/tpm/components.json'] = 'conf/jenkins/tpm/components.yaml',
        ['schemas/conf/jenkins/tpm/config.json'] = 'conf/jenkins/tpm/config.yaml',
        ['schemas/conf/jenkins/config.json'] = 'conf/jenkins/apw/config.yaml',
        ['schemas/conf/jenkins/components.json'] = 'conf/jenkins/apw/components.yaml',
        ['schemas/conf/pullrequests.json'] = 'conf/jenkins/pullrequests.yaml',
        ['schemas/data/env/env_file.json'] = 'data/env/*.yaml',
        ['schemas/profiles.json'] = 'profiles/**/*.yaml',
        ['schemas/products.json'] = 'products/**/*.yaml',
      },
    },
  },
})

lspconfig.solargraph.setup({
  -- Run solargraph per RVM env
  cmd = { 'solar-graph.sh' },
})

lspconfig.puppet.setup({
  -- TODO: puppet-lsp issue with definitions. Editor services bug?
  cmd = { 'puppet-languageserver', '--stdio', '--puppet-settings=--modulepath,/code/a32-tools:/code/puppet:/code/puppet-forge' },
})

lspconfig.ansiblels.setup({
  settings = {
    ansible = {
      -- ansible-lint runs from null-ls to ignore local .ansible-lint file.
      validation = {
        enabled = true,
        lint = {
          enabled = false,
        }
      }
    }
  }
})

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
})

--vim.lsp.set_log_level("debug")

lsp.setup()

local null_ls = require('null-ls')
local mason_null_ls = require('mason-null-ls')

null_ls.setup({
  debug = true,
  sources = {
    -- Shellcheck is used with bash LSP
    null_ls.builtins.diagnostics.shellcheck.with({
      filetypes = { 'none' },
    }),
    null_ls.builtins.diagnostics.npm_groovy_lint.with({
      filetypes = { 'groovy' },
      extra_args = { '-r', homedir .. '/.codenarc/default.groovy', '--no-parse' },
    }),
    null_ls.builtins.diagnostics.npm_groovy_lint.with({
      filetypes = { 'Jenkinsfile' },
      extra_args = { '-r', homedir .. '/.codenarc/jenkinsfile.groovy' },
    }),
    null_ls.builtins.diagnostics.ansiblelint.with({
      extra_args = { '-c', homedir .. '/.ansible-lint' },
    }),
    -- Rubocop run with solargraph
    null_ls.builtins.diagnostics.rubocop.with({
      filetypes = { 'none' },
    }),
  }
})
mason_null_ls.setup({
  ensure_installed = {
    'yamllint',
    'markdownlint',
    'pylint',
    'vint',
    'ansible-lint',
    -- 'npm_groovy_lint',
    'hadolint',
    'shellcheck',
    'trim_whitespace',
    'xmllint',
    'stylua',
    'ansiblelint',
    'rubocop',
  },
  automatic_installation = true,
  handlers = {},
})
