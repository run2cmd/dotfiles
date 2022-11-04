--
-- Custom commands
--
local cmd = vim.api.nvim_create_user_command

cmd('Todo', ":split ~/notes.md", {})
cmd('Config', ':e ~/dotfiles/nvim/init.lua', {})
cmd('Doc', ":lua require('run2cmd.helper-functions').chtsh('<args>')", { nargs = '*' })
cmd('Terminal', ":lua require('run2cmd.helper-functions').run_term_cmd('<args>')", { nargs = '*'})
