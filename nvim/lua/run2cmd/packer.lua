return require('packer').startup(function(use)
  -- Plugin manager
  use({ 'wbthomason/packer.nvim' })

  -- Movement
  use({
    'andymass/vim-matchup',
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  })

  -- File manager
  use({
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } },
  })

  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

  -- Auto completion and auto edit
  use({
    'hrsh7th/cmp-nvim-lsp',
    requires = { { 'neovim/nvim-lspconfig' } },
  })
  use({
    'hrsh7th/cmp-buffer',
    requires = { { 'hrsh7th/cmp-nvim-lsp' } },
  })
  use({
    'hrsh7th/cmp-path',
    requires = { { 'hrsh7th/cmp-nvim-lsp' } },
  })
  use({
    'hrsh7th/nvim-cmp',
    requires = { { 'hrsh7th/cmp-nvim-lsp' } },
  })
  use({
    'L3MON4D3/LuaSnip',
    requires = { { 'hrsh7th/cmp-nvim-lsp' } },
  })
  use({
    'saadparwaiz1/cmp_luasnip',
    requires = { { 'hrsh7th/cmp-nvim-lsp' } },
  })
  use({
    'nvim-lua/lsp-status.nvim',
    requires = { { 'neovim/nvim-lspconfig' } },
  })

  use({
    'kylechui/nvim-surround',
    tag = '*',
    config = function()
      require('nvim-surround').setup({})
    end,
  })
  use({
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        check_ts = true,
        disable_filetype = { 'TelescopePrompt' },
      })
    end,
  })
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({})
    end,
  })
  use({
    'mcauley-penney/tidy.nvim',
    config = function()
      require('tidy').setup({ filetype_exclude = { 'txt' } })
    end,
  })

  -- Syntax highlight
  use({ 'nvim-treesitter/nvim-treesitter' })
  use({
    'RRethy/nvim-treesitter-endwise',
    requires = { { 'nvim-treesitter/nvim-treesitter' } },
  })
  use({ 'martinda/Jenkinsfile-vim-syntax' })
  use({ 'aklt/plantuml-syntax' })

  -- Git support
  use({ 'tpope/vim-fugitive' })
  use({ 'lewis6991/gitsigns.nvim' })
  use({
    'sindrets/diffview.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
  })

  -- Looks
  use({
    'marko-cerovac/material.nvim',
    config = function()
      local colors = require('material.colors')
      vim.g.material_style = 'darker'
      require('material').setup({
        contrast = {
          floating_windows = true,
        },
        plugins = { 'gitsigns', 'telescope', 'nvim-cmp' },
        custom_highlights = {
          String = { fg = colors.main.darkgreen },
          ['@keyword.function.ruby'] = { fg = colors.main.darkred },
          --PuppetName = { fg = '#56b6c2' },
          DiagnosticUnderlineError = { underline = false },
          DiagnosticUnderlineWarn = { underline = false },
          DiagnosticUnderlineInfo = { underline = false },
          DiagnosticUnderlineHint = { underline = false },
        },
      })
      vim.cmd('colorscheme material')
    end,
  })
  use({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        char = '┊',
        fileTypeExclude = { 'startify', 'markdown', 'alpha' },
        bufTypeExclude = { 'finished', 'terminal', 'help', 'quickfix' },
      })
    end,
  })

  -- Fun stuff
  use({ 'goolord/alpha-nvim' })
  use({ 'ThePrimeagen/vim-be-good' })
end)
