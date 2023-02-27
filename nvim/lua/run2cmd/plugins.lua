vim.cmd('packadd! packer.nvim')

return require('packer').startup(function(use)
  -- Plugin manager
  use('wbthomason/packer.nvim')

  -- Libraries
  use('nvim-lua/plenary.nvim')

  -- colorschemes
  use('navarasu/onedark.nvim')

  -- Movement
  use('tpope/vim-unimpaired')
  use('andymass/vim-matchup')

  -- File manager
  use('nvim-telescope/telescope.nvim')

  -- Git support
  use('tpope/vim-fugitive')
  use('lewis6991/gitsigns.nvim')
  use({ 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' })

  -- Auto completion and auto edit
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use({ 'tzachar/cmp-tabnine', run = './install.sh' })
  use('L3MON4D3/LuaSnip')
  use('saadparwaiz1/cmp_luasnip')
  use('nvim-lua/lsp-status.nvim')
  use('kylechui/nvim-surround')
  use('dkarter/bullets.vim')
  use('dhruvasagar/vim-table-mode')
  use('noprompt/vim-yardoc')
  use('sbdchd/neoformat')
  use({
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  })
  --use 'nvim-treesitter/nvim-treesitter-context'
  use('RRethy/nvim-treesitter-endwise')
  use('nvim-treesitter/playground')
  use('windwp/nvim-autopairs')
  use('numToStr/Comment.nvim')
  use('mcauley-penney/tidy.nvim')

  -- Syntax and lint
  use('neovim/nvim-lspconfig')
  use('rodjek/vim-puppet')
  use('martinda/Jenkinsfile-vim-syntax')
  use('aklt/plantuml-syntax')
  use('Yggdroot/indentLine')

  -- Project support
  use('airblade/vim-rooter')
  use('gpanders/editorconfig.nvim')
  use('ludovicchabant/vim-gutentags')

  -- Database
  use('kristijanhusak/vim-dadbod-ui')

  -- Diff
  use('ZSaberLv0/ZFVimJob')
  use('ZSaberLv0/ZFVimIgnore')
  use('ZSaberLv0/ZFVimDirDiff')

  -- Fun stuff
  use('goolord/alpha-nvim')
  use('ThePrimeagen/vim-be-good')

  --
  -- https://github.com/ms-jpq/coq_nvim
  --
  -- IDEs to review:
  --  * https://github.com/VapourNvim/VapourNvim
  --  * https://github.com/askfiy/nvim
  --  * https://github.com/Abstract-IDE/Abstract
  --  * https://github.com/NvChad/NvChad
  --  * https://github.com/LunarVim/LunarVim
  --  * https://github.com/AstroNvim/AstroNvim
end)
