return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require("ts_context_commentstring").setup({})
        end,
      },
      { "RRethy/nvim-treesitter-endwise" },
      { "windwp/nvim-ts-autotag" },
      { "Hdoc1509/gh-actions.nvim" },
    },
    config = function()
      require("gh-actions.tree-sitter").setup()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          'lua',
          'bash',
          'python',
          'ruby',
          'vimdoc',
          'yaml',
          'json',
          'hcl',
          'markdown',
          'markdown_inline',
          'properties',
          'puppet',
          'groovy',
          'helm',
          'xml',
          'gh_actions_expressions'
        },
        auto_install = true,
        sync_install = false,
        highlight = {
          enable = true,
          disable = { "help" },
          additional_vim_regex_highlighting = false,
        },
        endwise = {
          enable = true,
        },
        matchup = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
        indent = {
          enable = true
        },
      })

      vim.g.skip_ts_context_commentstring_module = true
    end,
  },
}
