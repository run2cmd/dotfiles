local config = require('nvim-treesitter.configs')

-- Enable treesitter
config.setup({
  ensure_installed = { 'ruby', 'python', 'dockerfile', 'lua', 'json', 'yaml', 'vim', 'bash', 'comment', 'help', 'markdown' },
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  endwise = {
    enable = true,
  },
})
