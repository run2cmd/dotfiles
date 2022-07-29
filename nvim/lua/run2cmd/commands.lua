--
-- Custom commands
--
vim.api.nvim_create_user_command('Todo', ":e ~/notes.md", {})
vim.api.nvim_create_user_command('Config', ':e ~/dotfiles/nvim/init.lua', {})
vim.api.nvim_create_user_command('Doc', ":lua require('run2cmd.helper-functions').chtsh('<args>')", { nargs = '*' })
vim.api.nvim_create_user_command('Terminal', ':bo 15 split term://<args>', { nargs = '*'})
