local lspconfig = require('lspconfig')
local cmpnvimlsp = require('cmp_nvim_lsp')
local lsp_status = require('lsp-status')

-- Use Tags if LSP server does not return definitions
vim.o.tagfunc = "v:lua.vim.lsp.tagfunc"

-- Setup lsp_status
lsp_status.register_progress()
lsp_status.config({
  indicator_errors = 'E',
  indicator_warnings = 'W',
  indicator_info = 'I',
  indicator_hint = '?',
  indicator_ok = 'OK',
  select_symbol = false,
  show_filename = false,
})

-- Add snippet support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

--
-- Default lsp configuration for each server
--
-- @param _config Additional configuration passed to lspconfig.[server_name].setup
--
local function config(_config)
  return vim.tbl_deep_extend('force', {
    capabilities = cmpnvimlsp.update_capabilities(vim.tbl_extend('keep', vim.lsp.protocol.make_client_capabilities(), lsp_status.capabilities)),
    on_attach = function(_, bufnr)
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', "[d", vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', "]d", vim.diagnostic.goto_prev, opts)

      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      --vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      --vim.keymap.set('v', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
      vim.keymap.set('n', "<leader>vca", vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', "<leader>vrf", vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', "<leader>vrn", vim.lsp.buf.rename, bufopts)
    end
  }, _config or {})
end

-- Enable LSP servers
lspconfig.bashls.setup(config())
lspconfig.jedi_language_server.setup(config())
lspconfig.solargraph.setup(config())
lspconfig.puppet.setup(config({
  cmd = { 'puppetlsp.sh' },
}))
lspconfig.ansiblels.setup(config())
lspconfig.groovyls.setup(config({
  -- Do not autostart so Gradle files does not start new server
  autostart = false,
  -- Limit memory useage Groovy LS is heavy
  cmd = { "java", "-Xms256m", "-Xmx2048m", "-jar", "/home/pbugala/tools/groovy-language-server/build/libs/groovy-language-server-all.jar" },
}))
lspconfig.yamlls.setup(config({
  settings = {
    yaml = {
      -- Schemas to support ICHA
      -- TODO: support for SI
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
        ['schemas/products.json'] = 'products/**/*.yaml',
      }
    }
  }
}))
lspconfig.jsonls.setup(config())
lspconfig.vimls.setup(config())
lspconfig.ansiblels.setup(config({
  settings = {
    ansible = {
      -- Run ansible-lint with python env
      python = {
        interpreterPath = '/pyenv'
      },
      ansibleLint = {
        path = 'exec',
        arguments = 'ansible-lint -c ~/.ansible-lint'
      }
    },
  }
}))
lspconfig.dockerls.setup(config())
lspconfig.terraformls.setup(config())
lspconfig.sumneko_lua.setup(config({
  cmd = { '/home/pbugala/tools/lua-language-server/bin/luals.sh' },
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
  filetypes = { 'markdown', 'xml', 'groovy', 'Jenkinsfile' },
  init_options = {
    linters = {
      mdl = {
        sourceName = 'mdl',
        command = 'mdl',
        args = { '-j' },
        parseJson = {
          line = "line",
          column = "column",
          message = "[${rule}] ${description}",
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
            message = 2,
          }
        }
      },
      groovylint = {
        sourceName = 'groovylint',
        command = 'npm-groovy-lint',
        args = { '-r', '/home/pbugala/.codenarc.groovy', '-f', '**/%relativepath', '--noserver' },
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
        args = { '--stdin-fileptah', '%filepath' }
      }
    },
    formatFiletypes = {
      markdown = 'prettier'
    },
  }
}))

--vim.lsp.set_log_level 'trace'
--require('vim.lsp.log').set_format_func(vim.inspect)
