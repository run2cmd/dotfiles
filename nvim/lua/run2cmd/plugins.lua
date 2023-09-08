require("paq") {
  -- libs
  { 'nvim-lua/plenary.nvim' },

  -- Plugin manager
  { "savq/paq-nvim" },

  -- Movement
  { 'andymass/vim-matchup' },

  -- File manager
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x' },
  { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },

  -- Auto completion and auto edit
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/nvim-cmp' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'nvim-lua/lsp-status.nvim' },

  { 'kylechui/nvim-surround', tag = '*' },
  { 'windwp/nvim-autopairs' },
  { 'numToStr/Comment.nvim' },
  { 'mcauley-penney/tidy.nvim' },

  -- Syntax highlight
  { 'nvim-treesitter/nvim-treesitter' },
  { 'RRethy/nvim-treesitter-endwise' },
  { 'windwp/nvim-ts-autotag' },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  { 'martinda/Jenkinsfile-vim-syntax' },
  { 'aklt/plantuml-syntax' },

  -- Git support
  { 'tpope/vim-fugitive' },
  { 'lewis6991/gitsigns.nvim' },
  { 'sindrets/diffview.nvim' },

  -- Looks
  { 'marko-cerovac/material.nvim' },
  { 'nvimdev/indentmini.nvim' },

  -- Fun stuff
  { 'goolord/alpha-nvim' },
  { 'ThePrimeagen/vim-be-good' },

  -- To review
  -- https://github.com/ibhagwan/fzf-lua
}
