vim.o.swapfile = false
vim.o.confirm = true
vim.o.undofile = true
vim.o.path = vim.o.path .. ',**'
vim.o.grepprg = 'rg --vimgrep --hidden --no-ignore -S'
vim.o.switchbuf = 'useopen,usetab'
vim.o.updatetime = 50
vim.o.mouse = ''
vim.o.errorbells = false
vim.o.visualbell = true
vim.cmd("let mapleader = ' '")

vim.o.langmenu = 'en_US.UTF-8'
vim.env.LANG = 'en_US'
vim.o.spelllang = 'en_us'
vim.o.spellfile = vim.env.HOME .. '/.config/nvim/spell/en.utf8.add'
vim.o.spell = false

vim.o.completeopt = 'menu,menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'cm'
vim.o.complete = string.gsub(vim.o.complete, 't', '')

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cindent = true
vim.o.wildignore = '*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store'

vim.o.diffopt = vim.o.diffopt .. ',vertical,followwrap'

vim.o.formatoptions = vim.o.formatoptions .. 'jnM'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.joinspaces = false

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'

vim.o.list = true
vim.o.listchars = 'conceal:^,nbsp:+'
vim.o.linebreak = true

vim.o.scrolloff = 8
vim.o.sidescrolloff = 10

vim.g.netrw_home = vim.env.HOME
vim.g.netrw_fastbrowse = 0
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 0
vim.g.netrw_liststyle = 0
vim.g.netrw_sizestyle = 'H'
vim.g.netrw_silent = 1
vim.g.netrw_special_syntax = 1
vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro rnu'
vim.g.netrw_use_errorwindow = 1

vim.g.last_terminal_test = {}
vim.g.terminal_window_buffer_number = {}
