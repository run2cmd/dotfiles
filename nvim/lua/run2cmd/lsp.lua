local lspconfig = require('lspconfig')
local cmpnvimlsp = require('cmp_nvim_lsp')
local lsp_status = require('lsp-status')
local mapkey = vim.keymap.set
local homedir = vim.env.HOME

-- Use Tags if LSP server does not return definitions
vim.o.tagfunc = "v:lua.vim.lsp.tagfunc"

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
      mapkey('n', '<leader>vd', vim.diagnostic.open_float, opts)
      mapkey('n', "[d", vim.diagnostic.goto_next, opts)
      mapkey('n', "]d", vim.diagnostic.goto_prev, opts)

      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      mapkey('n', 'K', vim.lsp.buf.hover, bufopts)
      --mapkey('n', 'gd', vim.lsp.buf.definition, bufopts)
      --mapkey('v', 'gd', vim.lsp.buf.definition, bufopts)
      mapkey('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
      mapkey('n', "<leader>vca", vim.lsp.buf.code_action, bufopts)
      mapkey('n', "<leader>vrf", vim.lsp.buf.references, bufopts)
      mapkey('n', "<leader>vrn", vim.lsp.buf.rename, bufopts)
    end
  }, _config or {})
end

-- Enable LSP servers
lspconfig.bashls.setup(config())
lspconfig.jedi_language_server.setup(config())
lspconfig.solargraph.setup(config({
  filetypes = { 'ruby', 'rspec' },
}))
lspconfig.puppet.setup(config({
  cmd = { 'puppetlsp.sh' },
}))
lspconfig.groovyls.setup(config({
  filetypes = { 'groovy', 'groovy_test' },
  -- Limit memory useage Groovy LS is heavy
  cmd = { "java", "-Xms256m", "-Xmx2048m", "-jar", homedir .. "/tools/groovy-language-server/build/libs/groovy-language-server-all.jar" },
}))
lspconfig.gradle_ls.setup(config({
  filetypes = { 'gradle' },
  cmd = { homedir .. '/tools/vscode-gradle/gradle-language-server/build/install/gradle-language-server/bin/gradle-language-server' }
}))
lspconfig.yamlls.setup(config({
  settings = {
    yaml = {
      -- Schemas to support ICHA
      schemas = {
        ['schemas/conf/ansible.json'] = 'conf/ansible.json',
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
        interpreterPath = 'pyenv'
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
  cmd = { homedir .. '/tools/lua-language-server/bin/luals.sh' },
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
  filetypes = { 'markdown', 'xml', 'groovy', 'Jenkinsfile', 'python', 'groovy_test', 'gradle' },
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
        args = { '-r', homedir .. '/.codenarc/default.groovy', '-f', '**/%relativepath'},
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
      },
      jenkinslint = {
        sourceName = 'jenkinslint',
        command = 'npm-groovy-lint',
        args = { '-r', homedir .. '/.codenarc/jenkinsfile.groovy', '-f', '**/%relativepath'},
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
      },
      pylint = {
        sourceName = 'pylint',
        command = 'pylint',
        args = { '-f', 'text', '--msg-template', '{line}:{column}: {msg_id} {msg}', '%relativepath' },
        formatPattern = {
          '^(\\d+):(\\d+): (\\w)(.*)',
          {
            line = 1,
            column = 2,
            security = 3,
            message = { 3, 4 },
          }
        },
        securities = {
          error = 'E',
          warning = 'W',
          note = 'C',
        }
      }
    },
    filetypes = {
      markdown = 'mdl',
      xml = 'xmllint',
      groovy = 'groovylint',
      groovy_test = 'groovylint',
      gradle = 'groovylint',
      Jenkinsfile = 'jenkinslint',
      python = 'pylint',
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
