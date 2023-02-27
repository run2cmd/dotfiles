local config = require('nvim-treesitter.configs')
-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
--
-- -- Additional language support
-- parser_config.puppet = {
--   install_info = {
--     url = '~/tools/tree-sitter-puppet',
--     files = { 'src/parser.c' },
--     branch = 'main',
--     requires_generate_from_grammar = false,
--     generate_requires_npm = false,
--   },
-- }

-- Enable treesitter
config.setup({
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
