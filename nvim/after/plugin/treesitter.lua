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
