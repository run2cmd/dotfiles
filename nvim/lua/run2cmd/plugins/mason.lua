return {
  {
    {
      'mason-org/mason.nvim',
      name = 'mason',
      config = function()
        require("mason").setup()
      end
    },

    {
      'mason-org/mason-lspconfig.nvim',
      name = 'mason-lspconfig',
      dependencies = {
        'mason-org/mason.nvim',
        'neovim/nvim-lspconfig'
      },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = {
            'bashls',
            'jsonls',
            'vimls',
            'dockerls',
            'golangci_lint_ls',
            'ts_ls',
            'helm_ls',
            'marksman',
            'pylsp',
            'terraformls',
            'lua_ls',
            'ansiblels',
            'puppet',
            'yamlls',
            'solargraph',
            'ansible-lint',
            'flake8',
            'yapf',
            'shellcheck',
            'erb-lint',
            'erb-formatter',
            'rubocop',
            'diagnostic-languageserver',
            'npm-groovy-lint',
            'prettier',
            'vim-language-server',
            'stylua',
            'tflint',
            'hadolint'
          },
        })
      end
    },
  }
}
