"
" Name: Bugi Neovim
" Scriptname: .config/init.vim
" Original Author: Piotr Bugała <piotr.bugala@gmail.com> <https://github.com/run2cmd/dotfiles>
" License: The Vim License (this command will show it: ':help copyright')
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packadd! matchit

call plug#begin('~/.config/nvim/plugged')

" Libraries
Plug 'nvim-lua/plenary.nvim'

" File manager
Plug 'tpope/vim-unimpaired'
Plug 'nvim-telescope/telescope.nvim'

" Git support
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" Auto completion and auto edit
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'nvim-lua/lsp-status.nvim'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'Shougo/echodoc.vim'
Plug 'dkarter/bullets.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'noprompt/vim-yardoc'
Plug 'sbdchd/neoformat'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Project support
Plug 'airblade/vim-rooter'
Plug 'editorconfig/editorconfig-vim'
Plug 'ludovicchabant/vim-gutentags'

" Syntax and Lint
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'rodjek/vim-puppet'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'aklt/plantuml-syntax'
Plug 'Yggdroot/indentLine'

" Database
Plug 'kristijanhusak/vim-dadbod-ui'

" Diff
Plug 'ZSaberLv0/ZFVimDirDiff'

" Fun stuff
Plug 'mhinz/vim-startify'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Lua Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua require("run2cmd.telescope")
lua require('run2cmd.lsp')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Language, file encoding and format
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=en_US.UTF-8
let $LANG = 'en_US'
set spelllang=en_us
set spellfile=$HOME/.config/nvim/spell/en.utf8.add
set nospell

" Order matters
setglobal fileencoding=utf-8
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8
set termencoding=utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme bugi

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Files and directories
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do not use swapfile. Undo is enough.
set noswapfile

" Pop up window confirmation on write or quit with changes
set confirm

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Find and replace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Include files in current working directory
set path+=**

" Enable RipGrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --hidden\ --no-ignore\ -S
endif

" Enable FD find.
if executable('fdfind')
  let g:gutentags_file_list_command = 'fdfind --type f . spec/fixtures/modules .'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Diff mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set diffopt+=vertical
let g:ZFDirDiffFileExclude = 'CVS,.git,.svn'
let g:ZFDirDiffShowSameFile = 0

let g:signify_priority = 5

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Tabs and windows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabline=%{getcwd()}
set switchbuf=useopen,usetab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Text format
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set formatoptions+=jnM
set tabstop=2
set shiftwidth=2
set smartindent
set expandtab
set nojoinspaces

let g:neoformat_puppet_puppetlint = {
  \ 'exe': 'puppet-lint',
  \ 'args': ['--fix', '--no-autoloader_layout-check'],
  \ 'replace': 1,
\}
let g:neoformat_enabled_puppet = ['puppetlint']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Visual behavior
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set noerrorbells visualbell

set number
set relativenumber
set signcolumn=yes

set list
set listchars=conceal:^,nbsp:+
set linebreak

set scrolloff=2
set sidescrolloff=5

let g:indentLine_char = '┊'
let g:indentLine_fileTypeExclude = ['startify', 'markdown']
let g:indentLine_bufTypeExclude = ['finished', 'terminal', 'help', 'quickfix' ]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: File Explorer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Netrw pretty
let g:netrw_home = $HOME
let g:netrw_fastbrowse = 0
let g:netrw_banner = 0
let g:netrw_preview = 1
let g:netrw_winsize = 25
let g:netrw_altv = 1
let g:netrw_keepdir = 0
let g:netrw_liststyle = 0
let g:netrw_sizestyle = 'H'
let g:netrw_silent = 1
let g:netrw_special_syntax = 1
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro rnu'
let g:netrw_use_errorwindow = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Auto completion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command line completion
set wildmode=list:longest,full
set wildcharm=<Tab>
set ignorecase
set smartcase
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Vim build-in completion
set completeopt=menu,menuone,noinsert,noselect
set shortmess+=cm
set complete-=t
set complete-=i

" Enable Omni completion if not already set
set omnifunc=syntaxcomplete#Complete

let g:gutentags_cache_dir = stdpath("config") . '/tags'
let g:gutentags_project_root_finder = 'FindGutentagsRootDirectory'

" View function parameters in pop up window
let g:echodoc#enable_at_startup = 1

" Do not align hash rockets automatically for puppet
"let g:puppet_align_hashes = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Project work space
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rooter_silent_chdir = 1
let g:rooter_patterns = ['!^fixtures', '.git', '.svn', '.rooter']
let g:rooter_change_directory_for_non_project_files = 'current'
let g:startify_change_to_dir = 0
let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Performance
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=250

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Custom Auto commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcAuCmd
  autocmd!

  " Automatic doc generation for vim modules
  autocmd VimEnter :helptags ALL

  " Disable bell and blink
  autocmd GUIEnter * set visualbell t_vb=
  autocmd BufEnter * :syntax sync fromstart

  " Set title string
  autocmd BufFilePre,BufEnter,BufWinEnter,DirChanged *,!qf let &titlestring = ' ' . getcwd()

  " Set cursor at last position when opening files
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " File type support
  autocmd BufNewFile,BufReadPost .vimlocal,.vimterm,.viebrc,viebrclocal setlocal syntax=vim filetype=vim
  "autocmd FileType ruby setlocal foldmethod=manual re=1 lazyredraw
  autocmd FileType markdown setlocal spell
  autocmd FileType Terminal setlocal nowrap

  " Quick fix window behavior
  autocmd QuickFixCmdPost [^l]* copen 10
  autocmd QuickFixCmdPost    l* lopen 10
  autocmd FileType qf wincmd J

  " Close hidden buffers for Netrw
  autocmd FileType netrw setlocal bufhidden=wipe

  " Auto save
  autocmd CursorHold *
    \ if &modified != 0 && bufname('%') != "" &&
    \ index(["terminal", "nofile", "finished"], &buftype) < 0 &&
    \ index(["gitcommit", "startify"], &filetype) < 0 |
    \   write |
    \ endif

  "au FocusGained * :checktime
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Help and documentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup DocumentationCommands
  autocmd FileType python set keywordprg=:term\ ++shell\ python3\ -m\ pydoc
  autocmd FileType puppet set keywordprg=:term\ ++shell\ puppet\ describe
  autocmd FileType ruby set keywordprg=:term\ ++shell\ ri
  autocmd FileType groovy set keywordprg=:term\ ++shell\ $HOME\.vim\scripts\chtsh.bat\ groovy
augroup END

command -nargs=* Doc call CallChtsh("<args>")

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Keybindings and commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ' '

" Clear all buffers and run Startify
map <leader>l :bufdo %bd \| Startify<CR>

" Clear search and diff
if maparg('<c-l>', 'n') ==# ''
  nnoremap <silent> <c-l> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Do not use arrow keys for movement. Remap to resize commands
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vert resize +2<CR>
nnoremap <Right> :vert resize -2<CR>

" Tab enchantments
nnoremap <leader>o :tabnew<Bar>Startify<CR>
nnoremap <leader>w :tabnext<CR>
nnoremap <leader>b :tabprevious<CR>

" Terminal helper to open on the bottom
nnoremap <leader>c :split term://bash<CR>i<CR>

" Remap wildmenu navigation
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" Copy file path to + register
nnoremap <leader>f :let @+=expand('%:p')<CR>

" Telescope
nnoremap <C-p> <cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>
nnoremap <C-h> <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <C-k> <cmd>lua require('run2cmd.telescope').find_projects()<cr>
nnoremap <C-s> <cmd>lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<cr>

" Test automation
nnoremap `t :RunProjectTest<CR>
nnoremap `a :RunAlternativeTest<CR>
nnoremap `f :RunFile<CR>
nnoremap `l :RunLastTest<CR>
nnoremap <leader>e /FAILED\\|ERROR\\|Error\\|Failed<CR>

" Terminal support
tnoremap <C-W><leader>o <C-W>:tabnew<Bar>Startify<CR>
tnoremap <C-W><leader>w <C-W>:tabnext<CR>
tnoremap <C-W><leader>b <C-W>:tabprevious<CR>

" Jump to Git conflicts
nnoremap <leader>gc :Ggrep "^<<<<<"<CR>
nnoremap <leader>gb /^<<<<<<CR>
nnoremap <leader>gm /^=====<CR>
nnoremap <leader>ge /^>>>>><CR>

" Search word under cursor
nnoremap <leader>s viwy :Ggrep <C-R>"<CR>
vnoremap <leader>s y :Ggrep <C-R>"<CR>

" WSL support for Windows clipboard
vnoremap <leader>y "zy :call system('clip.exe', @z)<CR><CR>

" To do list
abbreviate todo ~/notes.md

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Startup Screen
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_lists = [
  \  { 'type': 'files', 'header': [' MRU'] },
  \  { 'type': 'bookmarks', 'header': [' Bookmarks'] },
  \]

let g:startify_bookmarks = [
  \  {'c': '~/dotfiles/nvim/init.vim'},
  \  {'b': '~/dotfiles/viebrc'},
  \  {'h': '/etc/hosts'},
  \  {'n': '~/notes.md'},
  \]

let g:startify_custom_header = [
  \ ' ______  _     _  ______ _____      __   _ _______  _____  _    _ _____ _______ ',
  \ ' |_____] |     | |  ____   |        | \  | |______ |     |  \  /    |   |  |  | ',
  \ ' |_____] |_____| |_____| __|__      |  \_| |______ |_____|   \/   __|__ |  |  | ',
  \ '',
  \ '                         Neovim ' . matchstr(execute('version'), 'NVIM v\zs[^\n]*'),
  \ ]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Status line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set cmdheight=2
set laststatus=2
set statusline=
set statusline+=[%{FugitiveHead(7)}]
set statusline+=\ %F
set statusline+=\ %y[%{&ff}]
set statusline+=[%{strlen(&fenc)?&fenc:&enc}a]
set statusline+=\ %h%m%r%w
set statusline+=
set statusline+=[%{LspStatus()}]

" Enable debug mode
"set verbose=20
"set verbosefile=~/vim.log
