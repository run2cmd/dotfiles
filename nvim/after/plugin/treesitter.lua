require('nvim-treesitter.configs').setup({
  -- ensure_installed = 'all',
  auto_install = true,
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
  autotag = {
    enable = true,
  },
})

vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup({})
