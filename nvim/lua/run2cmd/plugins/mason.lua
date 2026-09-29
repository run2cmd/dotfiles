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
            "jsonlint",
            "vint",
            "golangci-lint",
            "tflint",
            "luacheck",
            "sqlfluff",
            "standardrb",
          },
        })
      end,
    },
  },
}
