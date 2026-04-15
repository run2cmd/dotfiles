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

      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'lua',
          'bash',
          'groovy',
          'python',
          'yaml',
          'ruby',
          'json',
          'hcl',
          'markdown',
          'properties',
          'puppet',
          'groovy',
          'helm',
          'xml'
        },
        callback = function()
          vim.treesitter.start()
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'
          -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end
  },
}
