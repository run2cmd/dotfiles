vim.cmd('packadd! packer.nvim')

return require('packer').startup(function(use)
  -- Plugin manager
  use 'wbthomason/packer.nvim'

  -- Libraries
  use 'nvim-lua/plenary.nvim'

  -- Movement
  use 'tpope/vim-unimpaired'
  use 'Yggdroot/indentLine'

  -- File manager
  use 'nvim-telescope/telescope.nvim'

  -- Git support
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

  -- Auto completion and auto edit
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use { 'tzachar/cmp-tabnine', run = './install.sh' }
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'nvim-lua/lsp-status.nvim'
  use 'kylechui/nvim-surround'
  use 'tpope/vim-endwise'
  use 'dkarter/bullets.vim'
  use 'dhruvasagar/vim-table-mode'
  use 'noprompt/vim-yardoc'
  use 'sbdchd/neoformat'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end
  }
  use 'tversteeg/registers.nvim'
  use 'windwp/nvim-autopairs'
  use 'numToStr/Comment.nvim'

  -- Project support
  use 'airblade/vim-rooter'
  use 'gpanders/editorconfig.nvim'
  use 'ludovicchabant/vim-gutentags'

  -- Syntax and lint
  use 'neovim/nvim-lspconfig'
  use 'rodjek/vim-puppet'
  use 'martinda/Jenkinsfile-vim-syntax'
  use 'aklt/plantuml-syntax'
  use 'ellisonleao/glow.nvim'

  -- Database
  use 'kristijanhusak/vim-dadbod-ui'

  -- Diff
  use 'ZSaberLv0/ZFVimDirDiff'

  -- Fun stuff
  use 'goolord/alpha-nvim'
  use 'ThePrimeagen/vim-be-good'
end)
