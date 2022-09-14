--
-- Name: Bugi Neovim
-- Scriptname: .config/init.lua
-- Original Author: Piotr Bugała <piotr.bugala@gmail.com> <https://github.com/run2cmd/dotfiles>
-- License: The Vim License (this command will show it: ':help copyright')
--
local opt = vim.o
local cmd = vim.cmd

cmd('packadd! matchit')
opt.swapfile = false
opt.confirm = true
opt.undofile = true
opt.path = vim.o.path .. ',**'
opt.grepprg = 'rg --vimgrep --hidden --no-ignore -S'
opt.tabline = '%{getcwd()}'
opt.switchbuf = 'useopen,usetab'
opt.updatetime = 250
opt.mouse=""
cmd("let mapleader = ' '")

require('run2cmd.plugins')
require('run2cmd.helper-functions')
require('run2cmd.lang')
require('run2cmd.format')
require('run2cmd.diff')
require('run2cmd.telescope')
require('run2cmd.auto-completion')
require('run2cmd.lsp')
require('run2cmd.project-setup')
require('run2cmd.auto-commands')
require('run2cmd.netrw')
require('run2cmd.git')
require('run2cmd.keymap')
require('run2cmd.commands')
require('run2cmd.treesitter')

require("nvim-surround").setup()
require('Comment').setup()

require('run2cmd.get-some-fun')
require('run2cmd.pretty')
require('run2cmd.statusline')

-- Enable debug mode
--vim.o.verbose = 20
--vim.o.verbosefile = '~/vim.log'
