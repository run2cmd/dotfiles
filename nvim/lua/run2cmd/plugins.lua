vim.cmd('packadd! packer.nvim')

return require('packer').startup(function(use)
  -- Plugin manager
  use 'wbthomason/packer.nvim'

  -- Libraries
  use 'nvim-lua/plenary.nvim'

  -- File manager
  use 'tpope/vim-unimpaired'
  use 'nvim-telescope/telescope.nvim'

  -- Git support
  use 'tpope/vim-fugitive'
  use 'mhinz/vim-signify'

  -- Auto completion and auto edit
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use { 'tzachar/cmp-tabnine', run = './install.sh' }
  use 'nvim-lua/lsp-status.nvim'
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'
  use 'kylechui/nvim-surround'
  use 'tpope/vim-endwise'
  use 'Shougo/echodoc.vim'
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
  use 'numToStr/Comment.nvim'

  -- Project support
  use 'airblade/vim-rooter'
  use 'gpanders/editorconfig.nvim'
  use 'ludovicchabant/vim-gutentags'

  -- Syntax and lint
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp_extensions.nvim'
  use 'rodjek/vim-puppet'
  use 'martinda/Jenkinsfile-vim-syntax'
  use 'aklt/plantuml-syntax'
  use 'Yggdroot/indentLine'
  use 'ellisonleao/glow.nvim'

  -- Database
  use 'kristijanhusak/vim-dadbod-ui'

  -- Diff
  use 'ZSaberLv0/ZFVimDirDiff'

  -- Fun stuff
  use 'goolord/alpha-nvim'
  use 'ThePrimeagen/vim-be-good'
end)
