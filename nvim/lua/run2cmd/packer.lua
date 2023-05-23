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

  -- Syntax and lint
  use({ 'martinda/Jenkinsfile-vim-syntax' })
  use({ 'aklt/plantuml-syntax' })

  -- Auto completion and auto edit
  use({
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'jose-elias-alvarez/null-ls.nvim' },
      { 'jay-babu/mason-null-ls.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-path' },
      { 'nvim-lua/lsp-status.nvim' },
    },
  })

  use({
    'kylechui/nvim-surround',
    tag = '*',
    config = function()
      require('nvim-surround').setup({})
    end,
  })
  use({ 'noprompt/vim-yardoc' })
  use({
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'all',
        sync_install = false,
        highlight = {
          enable = true,
          disable = { 'help' },
          additional_vim_regex_highlighting = false,
        },
        endwise = {
          enable = true,
        },
        matchup = {
          enable = true,
        },
      })
    end,
  })
  use({
    'RRethy/nvim-treesitter-endwise',
    requires = { { 'nvim-treesitter/nvim-treesitter' } },
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

  -- Project support
  use({
    'airblade/vim-rooter',
    config = function()
      vim.g.rooter_silent_chdir = 1
      vim.g.rooter_patterns = { '!^fixtures', '.git', '.svn', '.rooter' }
      vim.g.rooter_change_directory_for_non_project_files = 'current'
    end,
  })
  use({
    'gpanders/editorconfig.nvim',
    config = function()
      vim.g.EditorConfig_exclude_patterns = { 'fugitive://.\\*', 'scp://.\\*' }
      require('editorconfig').properties.max_line_length = function(bufnr, val, opts)
        if opts.max_line_length then
          if opts.max_line_length == 'off' then
            vim.bo[bufnr].textwidth = 0
          else
            vim.bo[bufnr].textwidth = tonumber(val)
          end
        end
      end
    end,
  })

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
