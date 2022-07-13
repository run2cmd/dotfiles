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
  use 'tpope/vim-surround'
  --use 'kylechui/nvim-surround'
  use 'tpope/vim-endwise'
  use 'Shougo/echodoc.vim'
  use 'dkarter/bullets.vim'
  use 'dhruvasagar/vim-table-mode'
  use 'noprompt/vim-yardoc'
  use 'sbdchd/neoformat'
  use { 'nvim-treesitter/nvim-treesitter',  run = ':TSUpdate' }
  --use 'tversteeg/registers.nvim'
  --use 'b3nj5m1n/kommentary'
  --use 'numToStr/Comment.nvim'
  --use 'gelguy/wilder.nvim'

  -- Project support
  use 'airblade/vim-rooter'
  --use 'ahmedkhalf/project.nvim'
  use 'editorconfig/editorconfig-vim'
  --use 'gpanders/editorconfig.nvim'
  use 'ludovicchabant/vim-gutentags'
  --use 'aserowy/tmux.nvim'

  -- Syntax and lint
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp_extensions.nvim'
  use 'rodjek/vim-puppet'
  use 'martinda/Jenkinsfile-vim-syntax'
  use 'aklt/plantuml-syntax'
  use 'Yggdroot/indentLine'
  --use 'ellisonleao/glow.nvim'

  -- Database
  use 'kristijanhusak/vim-dadbod-ui'

  -- Diff
  use 'ZSaberLv0/ZFVimDirDiff'

  -- Fun stuff
  use 'mhinz/vim-startify'
  --use 'startup-nvim/startup.nvim'
  --use 'goolord/alpha-nvim'
  --use 'luisiacc/gruvbox-baby'
  --use 'ThePrimeagen/vim-be-good'
  --
end)
