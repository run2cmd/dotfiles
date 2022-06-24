local cmp = require('cmp')
local tabnine = require('cmp_tabnine.config')
local lspconfig = require('lspconfig')
local cmpnvimlsp = require('cmp_nvim_lsp')
local lsp_status = require('lsp-status')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<c-k>'] = cmp.mapping.select_prev_item(),
    ['<c-j>'] = cmp.mapping.select_next_item(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'cmp_tabnine' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },
})

tabnine:setup({
  max_lines = 1000,
  max_num_results = 20,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = "..",
})

lsp_status.register_progress()
lsp_status.config({
  indicator_errors = 'E',
  indicator_warnings = 'W',
  indicator_info = 'I',
  indicator_hint = '?',
  indicator_ok = '✓',
  select_symbol = false,
  show_filename = false,
})

capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function config(_config)
  return vim.tbl_deep_extend('force', {
    capabilities = cmpnvimlsp.update_capabilities(vim.tbl_extend('keep', vim.lsp.protocol.make_client_capabilities(), lsp_status.capabilities)),
    on_attach = function(client, bufnr)
      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', "[d", vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', "]d", vim.diagnostic.goto_prev, opts)

      local bufopts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
      vim.keymap.set('n', "<leader>vca", vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', "<leader>vrf", vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', "<leader>vrn", vim.lsp.buf.rename, bufopts)
      vim.keymap.set('i', "<C-h>", vim.lsp.buf.signature_help, bufopts)
    end
  }, _config or {})
end

lspconfig.bashls.setup(config())
lspconfig.jedi_language_server.setup(config())
lspconfig.solargraph.setup(config())
lspconfig.puppet.setup(config({
  cmd = { 'puppet-languageserver', '--stdio', '--puppet-settings=--modulepath=spec/fixtures/modules' },
}))
lspconfig.groovyls.setup(config({
  cmd = { "java", "-jar", "/home/pbugala/tools/groovy-language-server/build/libs/groovy-language-server-all.jar" },
}))
lspconfig.yamlls.setup(config({
  settings = {
    yaml = {
      schemas = {
        ['schemas/conf/ansible.json'] = 'conf/ansible.json',
        ['schemas/conf/jenkins/endpoints.json'] = 'conf/jenkins/endpoints.yaml',
        ['schemas/conf/jenkins/config.json'] = 'conf/jenkins/apw/config.yaml',
        ['schemas/conf/jenkins/components.json'] = 'conf/jenkins/apw/components.yaml',
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
        ['schemas/conf/pullrequests.json'] = 'conf/jenkins/pullrequests.yaml',
        ['schemas/data/env/env_file.json'] = 'data/env/*.yaml',
        ['schemas/profiles.json'] = 'profiles/**/*.yaml',
      }
    }
  }
}))
lspconfig.jsonls.setup(config())
lspconfig.vimls.setup(config())
lspconfig.ansiblels.setup(config())
lspconfig.dockerls.setup(config())
lspconfig.terraformls.setup(config())
lspconfig.sumneko_lua.setup(config({
  cmd = { '/home/pbugala/tools/bin/luals.sh' },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
    },
  }
}))
lspconfig.diagnosticls.setup(config({
  filetypes = {'markdown', 'xml', 'groovy', 'Jenkinsfile'},
  init_options = {
    linters = {
      mdl = {
        sourceName = 'mdl',
        command = 'mdl',
        args = {'-j'},
        parseJson = {
          line = "line",
          column = "column",
          message = "[${rule}] ${description}",
        }
      },
      xmllint = {
        sourceName = 'xmllint',
        command = 'xmllint',
        args = {'--noout', '-'},
        isStderr = true,
        formatLines = 1,
        formatPattern = {
          '^[^:]+:(\\d+):(.*)$',
          {
            line = 1,
            message = 2,
          }
        }
      },
      groovylint = {
        sourceName = 'groovylint',
        command = 'npm-groovy-lint',
        args = {'-r', '/home/pbugala/.codenarc.groovy', '-f', '**/%relativepath', '--noserver'},
        isStderr = true,
        isStdout = true,
        formatLines = 1,
        formatPattern = {
          '^[ ]+(\\d+)[ ]+.*90m(\\w+).*39m(.*)',
          {
            line = 1,
            security = 2,
            message = 3,
          }
        }
        --parseJson = {
        --  errorsRoot = 'files.%filepath.errors',
        --  line = 'line',
        --  security = 'severity',
        --  message = '[${rule}] ${msg}',
        --}
      },
    },
    filetypes = {
      markdown = 'mdl',
      xml = 'xmllint',
      groovy = 'groovylint',
      Jenkinsfile = 'groovylint',
    },
    formatters = {
      prettier = {
        command = 'prettier',
        args = {'--stdin-fileptah', '%filepath'}
      }
    },
    formatFiletypes = {
      markdown = 'prettier'
    },
  }
}))

--vim.lsp.set_log_level 'trace'
--require('vim.lsp.log').set_format_func(vim.inspect)
