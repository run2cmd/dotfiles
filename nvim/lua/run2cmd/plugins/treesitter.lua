return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      { "Hdoc1509/gh-actions.nvim",
        config = function()
          require("gh-actions.tree-sitter").setup()
        end
      },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require("ts_context_commentstring").setup({})
          vim.g.skip_ts_context_commentstring_module = true
        end,
      },
      { "nvim-treesitter/nvim-treesitter-context" },
      { "RRethy/nvim-treesitter-endwise" },
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require('nvim-ts-autotag').setup()
        end
      }
    },
    config = function()
      require('nvim-treesitter').install({
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
      }):wait(600000)

      -- Disable treesitter highlighting for bash: the tree-sitter-bash grammar
      -- misparses '[' inside parameter expansion defaults (e.g. ${1:-[].name}),
      -- breaking syntax from that point. Keeping the parser installed still
      -- provides indentation, text-objects, and context features.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'bash', 'sh' },
        callback = function()
          vim.treesitter.stop()
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'lua',
          'groovy',
          'Jenkinsfile',
          'python',
          'yaml',
          'yaml.ansible',
          'ruby',
          'json',
          'hcl',
          'markdown',
          'properties',
          'puppet',
          'helm',
          'xml'
        },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end
  },
}
