--
-- Name: Bugi Neovim
-- Original Author: Piotr Bugała <piotr.bugala@gmail.com> <https://github.com/run2cmd/dotfiles>
-- License: The Vim License (this command will show it: ':help copyright')
--
require('run2cmd.vimset')
require('run2cmd.helper-functions')
require('run2cmd.packer')
require('run2cmd.filetypes')
require('run2cmd.auto-commands')
require('run2cmd.tests')
require('run2cmd.keymap')
require('run2cmd.commands')
require('run2cmd.statusline')
require('run2cmd.autochdir')
require('run2cmd.travel')

-- Enable debug mode
-- vim.o.verbose = 20
-- vim.o.verbosefile = '~/vim.log'
