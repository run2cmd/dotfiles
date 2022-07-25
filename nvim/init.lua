--
-- Name: Bugi Neovim
-- Scriptname: .config/init.lua
-- Original Author: Piotr Bugała <piotr.bugala@gmail.com> <https://github.com/run2cmd/dotfiles>
-- License: The Vim License (this command will show it: ':help copyright')
--
-----------------------------
-- Plugins
-----------------------------
vim.cmd('packadd! matchit')
require('run2cmd.plugins')

require('run2cmd.telescope')
require('run2cmd.lsp')
require('run2cmd.project-tests')
require('run2cmd.helper-functions')

require("nvim-surround").setup()
require('Comment').setup()

require('run2cmd.get-some-fun')

-- TODO:
--  Treesitter with supported colorscheme

-----------------------------
-- Language and encoding
-----------------------------
vim.o.langmenu = 'en_US.UTF-8'
vim.env.LANG = 'en_US'
vim.o.spelllang = 'en_us'
vim.o.spellfile = vim.env.HOME .. '/.config/nvim/spell/en.utf8.add'
vim.o.spell = false

vim.go.fileencoding = 'utf-8'
vim.o.encoding = 'utf-8'
vim.o.fileencodings = 'utf-8'
vim.o.termencoding = 'utf-8'

-----------------------------
-- Colors
-----------------------------
vim.cmd('colorscheme bugi')

-----------------------------
-- Files and directories
-----------------------------
vim.o.swapfile = false
vim.o.confirm = true
vim.o.undofile = true

-----------------------------
-- Find and replace
-----------------------------
vim.o.path = vim.o.path .. ',**'
vim.o.grepprg = 'rg --vimgrep --hidden --no-ignore -S'

-----------------------------
-- Diff mode
-----------------------------
vim.o.diffopt = vim.o.diffopt .. ',vertical'
vim.g.ZFDirDiffFileExclude = 'CVS,.git,.svn'
vim.g.ZFDirDiffShowSameFile = 0

vim.g.signify_priority = 5

-----------------------------
-- Tabs and windows
-----------------------------
vim.o.tabline = '%{getcwd()}'
vim.o.switchbuf = 'useopen,usetab'

-----------------------------
-- Text format
-----------------------------
vim.o.formatoptions = vim.o.formatoptions .. 'jnM'
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.joinspaces = false

vim.g.neoformat_puppet_puppetlint = {
  exe = 'puppet-lint',
  args = { '--fix', '--no-autoloader_layout-check' },
  ['replace'] = 1
}
vim.g.neoformat_enabled_puppet = { 'puppetlint' }

-----------------------------
-- Visual behavior
-----------------------------
vim.o.noerrorbells = 'visualbell'

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'

vim.o.list = true
vim.o.listchars = 'conceal:^,nbsp:+'
vim.o.linebreak = true

vim.o.scrolloff = 2
vim.o.sidescrolloff = 5

vim.g.indentLine_char = '┊'
vim.g.indentLine_fileTypeExclude = { 'startify', 'markdown' }
vim.g.indentLine_bufTypeExclude = { 'finished', 'terminal', 'help', 'quickfix' }

-----------------------------
-- File Explorer
-----------------------------
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

-----------------------------
-- Auto completion
-----------------------------
--vim.o.wildmode = 'list:longest,full'
vim.o.wildcharm = '<Tab>'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildignore = '*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store'

-- Vim build-in completion
vim.o.completeopt = 'menu,menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess ..'cm'
vim.o.complete = string.gsub(vim.o.complete, 't', '')

-- Enable Omni completion if not already set
vim.o.omnifunc = 'syntaxcomplete#Complete'

-- Gutentags setup
vim.g.gutentags_file_list_command = 'fdfind --type f . spec/fixtures/modules .'
vim.g.gutentags_cache_dir = vim.env.HOME .. '/.config/nvim/tags'
--vim.g.gutentags_project_root_finder = 'FindGutentagsRootDirectory'

-- View function parameters in pop up window
vim.g['echodoc#enable_at_startup'] = 1

-- Project work space
vim.g.rooter_silent_chdir = 1
vim.g.rooter_patterns = { '!^fixtures', '.git', '.svn', '.rooter' }
vim.g.rooter_change_directory_for_non_project_files = 'current'
vim.g.startify_change_to_dir = 0
vim.g.EditorConfig_exclude_patterns = { 'fugitive://.\\*', 'scp://.\\*' }

-----------------------------
-- Performance
-----------------------------
vim.o.updatetime = 250

-----------------------------
-- Custom Auto commands
-----------------------------
local autocmds = {
  doc_generation = {
    -- Update Helptags on start
    { event = { 'VimEnter' }, opts = { command = 'helptags ALL'} }
  },
  disable_bell = {
    -- Disable blink and bell
    { event = { 'GUIEnter' }, opts =  { pattern = '*', command = 'set visualbell t_vb=' } },
    { event = { 'BufEnter' }, opts = { pattern = '*', command = 'syntax sync fromstart' } }
  },
  set_title = {
    -- Set Title string for Tabs
    {
      event = { 'BufFilePre', 'BufEnter', 'BufWinEnter', 'DirChanged' },
      opts = { pattern = { '*', '!qf' }, command = 'let &titlestring = " " . getcwd()' }
    }
  },
  reopen_buffers = {
    -- Set cursor at last position when opening files
    {
      event = { 'BufReadPost' },
      opts = {
        pattern = '*',
        command = "lua require('run2cmd.helper-functions').goto_last_position()"
      }
    }
  },
  filetypes = {
    {
      event = { 'BufNewFile' , 'BufReadPost' },
      opts = { pattern = '.vimlocal,.vimterm,.viebrc,viebrc,viebrclocal', command = 'setlocal syntax=vim filetype=vim' }
    },
    {
      event = { 'BufNewFile' , 'BufReadPost', 'BufEnter', 'BufWinEnter' },
      opts = { pattern = '*.yaml,*.yml', command = 'lua require("run2cmd.helper-functions").set_filetype("yaml.ansible", "yaml.ansible")' }
    },
    { event = { 'FileType' }, opts = { pattern = 'markdown', command = 'setlocal spell' } },
    { event = { 'FileType' }, opts = { pattern = 'Terminal', command = 'setlocal nowrap' } }
  },
  quickfix_window = {
    { event = { 'QuickFixCmdPost' }, opts = { pattern = '[^l]*', command = 'copen 10' } },
    { event = { 'QuickFixCmdPost' }, opts = { pattern = 'l*', command = 'lopen 10' } },
    { event = { 'FileType' }, opts = { pattern = 'qf', command = 'wincmd J' } },
    -- Close hidden buffers for Netrw
    { event = { 'FileType' }, opts = { pattern = 'netrw', command = 'setlocal bufhidden=wipe' } }
  },
  autosave = {
    { event = { 'CursorHold' }, opts = { pattern = '*', command = "lua require('run2cmd.helper-functions').autosave()" } },
  },
  auto_docs = {
    { event = { 'FileType' }, opts = { pattern = 'python', command = 'set keywordprg=:term\\ ++shell\\ python3\\ -m\\ pydoc' } },
    { event = { 'FileType' }, opts = { pattern = 'puppet', command = 'set keywordprg=:term\\ ++shell\\ puppet\\ describe' } },
    { event = { 'FileType' }, opts = { pattern = 'ruby', command = 'set keywordprg=:term\\ ++shell\\ ri' } },
--    { event = { 'BufEnter' }, opts = { pattern = 'groovy', command = 'set keywordprg=:term\\ ++shell\\ $HOME/.vim/scripts/chtsh.bat groovy' } },
  }
}
for group_name, cmds in pairs(autocmds) do
  vim.api.nvim_create_augroup(group_name, { clear = true })
  for k, v in pairs(cmds) do
    v.opts.group = group_name
    vim.api.nvim_create_autocmd(v.event, v.opts)
  end
end

-----------------------------
-- Keybindings and commands
-----------------------------
local mapkey = vim.api.nvim_set_keymap
vim.cmd("let mapleader = ' '")

-- Clear all buffers and run Startify
mapkey('', '<leader>l', ':bufdo %bd | Alpha<CR>', {})

-- Clear search and diff
mapkey('n', '<silent> <c-l>', ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>", {})

-- Do not use arrow keys for movement. Remap to resize commands
mapkey('n', '<Up>', ':resize +2<CR>', {})
mapkey('n', '<Down>', ':resize -2<CR>', {})
mapkey('n', '<Left>', ':vert resize +2<CR>', {})
mapkey('n', '<Right>', ':vert resize -2<CR>', {})

-- Tab enchantments
mapkey('n', '<leader>o', ':tabnew<Bar>Startify<CR>', {})
mapkey('n', '<leader>w', ':tabnext<CR>', {})
mapkey('n', '<leader>b', ':tabprevious<CR>', {})

-- Terminal helper to open on the bottom
mapkey('n', '<leader>c', ':split term://bash<CR>i<CR>', {})

-- Remap wildmenu navigation
mapkey('c', '<C-k>', '<Up>', {})
mapkey('c', '<C-j>', '<Down>', {})

-- Copy file path to + register
mapkey('n', '<leader>f', ":let @+=expand('%:p')<CR>", {})

-- Terminal support
mapkey('t', '<C-W><leader>o', '<C-W>:tabnew<Bar>Startify<CR>', {})
mapkey('t', '<C-W><leader>w', '<C-W>:tabnext<CR>', {})
mapkey('t', '<C-W><leader>b', '<C-W>:tabprevious<CR>', {})

-- Jump to Git conflicts
mapkey('n', '<leader>gc', ':Ggrep "^<<<<<"<CR>', {})
mapkey('n', '<leader>gb', '/^<<<<<<CR>', {})
mapkey('n', '<leader>gm', '/^=====<CR>', {})
mapkey('n', '<leader>ge', '/^>>>>><CR>', {})

-- Move around projects
mapkey('n', '<C-p>', ":lua require('telescope.builtin').find_files({hidden=true})<cr>", {})
mapkey('n', '<C-h>', ":lua require('telescope.builtin').buffers()<cr>", {})
mapkey('n', '<C-k>', ":lua require('run2cmd.telescope').find_projects()<cr>", {})
mapkey('n', '<C-s>', ":lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<cr>", {})

-- Search word under cursor
mapkey('n', '<leader>s', 'viwy :Ggrep <C-R>"<CR>', {})
mapkey('v', '<leader>s', 'y :Ggrep <C-R>"<CR>', {})

-- WSL support for Windows clipboard
mapkey('v', '<leader>y', '"zy :call system(\'clip.exe\', @z)<CR><CR>', {})

-- Easy close terminal
mapkey('t', '<C-W>e', '<C-\\><C-N>', {})

-- Easy goto
vim.api.nvim_create_user_command('Todo', ":e ~/notes.md", {})
vim.api.nvim_create_user_command('Config', ':e ~/dotfiles/nvim/init.lua', {})
vim.api.nvim_create_user_command('Doc', ":lua require('run2cmd.helper-functions').chtsh('<args>')", { nargs = '*' })

-- Easy terminal
vim.api.nvim_create_user_command('Terminal', ':bo 15 split term://<args>', { nargs = '*'})

-----------------------------
-- Status line
-----------------------------
vim.o.cmdheight = 2
vim.o.laststatus = 2

function Status_line()
  return table.concat {
    '[%{FugitiveHead(7)}]',
    ' %F',
    ' %y[%{&ff}]',
    '[%{strlen(&fenc)?&fenc:&enc}a]',
    ' %h%m%r%w',
    '[',
    require('lsp-status').status(),
    ']'
  }
end
vim.o.statusline = "%!luaeval('Status_line()')"

-- Enable debug mode
--vim.o.verbose = 20
--vim.o.verbosefile = '~/vim.log'
