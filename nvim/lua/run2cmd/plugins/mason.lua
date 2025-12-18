return {
  {
    {
      "mason-org/mason.nvim",
      config = function()
        require("mason").setup()
      end,
    },

    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      dependencies = { "mason-org/mason.nvim" },
      config = function()
        require("mason-tool-installer").setup({
          ensure_installed = {
            "shellcheck",
            "yapf",
            "prettier",
            "yamllint",
            "flake8",
            "ansible-lint",
            "erb-lint",
            "stylua",
            "npm-groovy-lint",
            "hadolint",
            "rumdl",
          },
        })
      end,
    },

    {
      "mason-org/mason-lspconfig.nvim",
      name = "mason-lspconfig",
      dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("mason-lspconfig").setup({
          automatic_enable = true,
          ensure_installed = {
            "bashls",
            "jsonls",
            "vimls",
            "dockerls",
            "golangci_lint_ls",
            "helm_ls",
            "marksman",
            "pylsp",
            "terraformls",
            "lua_ls",
            "ansiblels",
            "puppet",
            "yamlls",
            "stylua",
            "sqlls",
            "diagnosticls",
            "gradle_ls",
            "groovyls",
            "puppet",
            "lemminx",
          },
        })
      end,
    },
  },
}
