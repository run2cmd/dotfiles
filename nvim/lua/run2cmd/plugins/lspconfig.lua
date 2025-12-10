return {
  { "b0o/SchemaStore.nvim" },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-lua/lsp-status.nvim",
    },
    config = function()
      local mapkey = vim.keymap.set
      local schemas = require("schemastore")
      local lsp_status = require("lsp-status")
      local cmp_lsp = require("cmp_nvim_lsp")

      vim.lsp.config("*", {
        capabilities = cmp_lsp.default_capabilities(vim.tbl_extend("keep", vim.lsp.protocol.make_client_capabilities(), lsp_status.capabilities)),
        on_attach = function(_, bufnr)
          local opts = { noremap = true, silent = true, buffer = bufnr }
          mapkey("n", "<leader>qf", vim.diagnostic.setqflist, opts)
          mapkey("n", "<leader>bf", vim.lsp.buf.format, opts)
          mapkey("n", "<leader>br", vim.lsp.buf.rename, opts)
          mapkey("n", "<leader>vr", vim.lsp.buf.references, opts)
          mapkey("n", "]d", vim.diagnostic.goto_next, opts)
          mapkey("n", "[d", vim.diagnostic.goto_prev, opts)
        end,
      })

      vim.lsp.config("bashls", {
        settings = {
          bashIde = {
            shellcheckArguments = { "-x" },
          },
        },
      })

      vim.lsp.config("pylsp", {
        settings = {
          pylsp = {
            configurationSources = { "flake8" },
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
      })

      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = schemas.json.schemas(),
            validate = { enable = true },
          },
        },
      })

      vim.lsp.config("terraformls", { filetypes = { "hcl", "tf" } })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                library = { vim.env.VIMRUNTIME },
              },
            },
          },
        },
      })

      vim.lsp.config("ansiblels", {
        settings = {
          ansible = {
            ansible = {
              useFullyQualifiedCollectionNames = false,
            },
            python = {
              interpreterPath = "pyenv",
            },
            validation = {
              lint = {
                path = "exec",
                arguments = "ansible-lint",
              },
            },
          },
        },
      })

      vim.lsp.enable("ruby_lsp")

      vim.lsp.config("puppet", { cmd = { "puppet-languageserver", "--stdio", "--puppet-settings=--modulepath,/code" } })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            format = { enable = true },
            validate = true,
            hoover = true,
            completion = true,
            schemas = (function()
              local ok, schemastore = pcall(require, "schemastore")
              local base = ok and schemastore.yaml.schemas() or {}
              base["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = { "**/.azuredevops/**/*.yaml" }
              return base
            end)(),
            schemaStore = {
              enable = false,
              url = "https://www.schemastore.org/api/json/catalog.json",
            },
          },
        },
      })

      vim.lsp.config("diagnosticls", {
        filetypes = { "xml", "eruby", "lua", "markdown", "groovy", "Jenkinsfile" },
        init_options = {
          linters = {
            mdl = {
              sourceName = "mdl",
              command = "rumdl",
              args = { "check", "%relativepath" },
              formatLines = 1,
              formatPattern = {
                ".*:(\\d+):(.*)",
                {
                  line = 1,
                  message = { "[mdl]", 2 },
                },
              },
            },
            erb = {
              sourceName = "erb",
              command = "erbvalidate",
              args = { "%relativepath" },
              isStderr = true,
              formatLines = 1,
              formatPattern = {
                "^-:(\\d+):(.*)$",
                {
                  line = 1,
                  message = { "[erb]", 2 },
                },
              },
            },
            groovylint = {
              sourceName = "groovylint",
              command = "npm-groovy-lint",
              args = { "--codenarcargs -report=console %relativepath" },
              rootPatterns = { ".git" },
              formatLines = 1,
              formatPattern = {
                "Violation: Rule=(.*) P=(\\d+) Line=(\\d+) Msg=\\[(.*)\\] Src=",
                {
                  security = 2,
                  line = 3,
                  message = { "[groovylint]", " [", 1, "] ", 4 },
                },
              },
              securities = {
                ["1"] = "error",
                ["2"] = "warning",
                ["3"] = "info",
              },
            },
            xmllint = {
              sourceName = "xmllint",
              command = "xmllint",
              args = { "--noout", "-" },
              isStderr = true,
              formatLines = 1,
              formatPattern = {
                "^[^:]+:(\\d+):(.*)$",
                {
                  line = 1,
                  message = { "[xmllint]", 2 },
                },
              },
            },
          },
          filetypes = {
            eruby = "erb",
            markdown = "mdl",
            groovy = "groovylint",
            Jenkinsfile = "groovylint",
            xml = "xmllint",
          },
          formatters = {
            stylua = {
              command = "stylua",
              args = { "--color", "Never", "-" },
              rootPatterns = { ".git" },
            },
          },
          formatFiletypes = {
            lua = "stylua",
          },
        },
      })
      -- vim.lsp.set_log_level('debug')
    end,
  },
}
