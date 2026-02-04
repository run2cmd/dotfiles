return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
      "hrsh7th/cmp-nvim-lsp",
      {
        "nvim-lua/lsp-status.nvim",
        config = function()
          local lsp_status = require("lsp-status")
          lsp_status.register_progress()
          lsp_status.config({
            status_symbol = "",
            indicator_errors = "E",
            indicator_warnings = "W",
            indicator_info = "I",
            indicator_hint = "?",
            indicator_ok = "OK",
            select_symbol = false,
            show_filename = false,
          })
        end,
      },
    },
    config = function()
      local schemas = require("schemastore")
      local lsp_status = require("lsp-status")
      local cmp_lsp = require("cmp_nvim_lsp")

      vim.lsp.config("*", {
        capabilities = cmp_lsp.default_capabilities(vim.tbl_extend("keep", vim.lsp.protocol.make_client_capabilities(), lsp_status.capabilities)),
        on_attach = function(_, bufnr)
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
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
      -- vim.lsp.set_log_level('debug')
    end,
  },
}
