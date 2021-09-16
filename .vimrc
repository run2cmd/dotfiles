"
"        ________  ___  ___  ________  ___          ___      ___ ___  _____ ______       
"       |\   __  \|\  \|\  \|\   ____\|\  \        |\  \    /  /|\  \|\   _ \  _   \       
"       \ \  \|\ /\ \  \\\  \ \  \___|\ \  \       \ \  \  /  / | \  \ \  \\\__\ \  \     
"        \ \   __  \ \  \\\  \ \  \  __\ \  \       \ \  \/  / / \ \  \ \  \\|__| \  \   
"         \ \  \|\  \ \  \\\  \ \  \|\  \ \  \       \ \    / /   \ \  \ \  \    \ \  \  
"          \ \_______\ \_______\ \_______\ \__\       \ \__/ /     \ \__\ \__\    \ \__\ 
"           \|_______|\|_______|\|_______|\|__|        \|__|/       \|__|\|__|     \|__| 
"
"
"
" Name: Bugi VIM
" Scriptname: .vimrc
" Original Author: Piotr Bugała <piotr.bugala@gmail.com> <https://github.com/run2cmd/dotfiles>
" For GVim: Yes
" License: The Vim License (this command will show it: ':help copyright')
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Defaults
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype plugin indent on

" Load matchit
packadd! matchit

" No sounds
set noerrorbells visualbell t_vb=

" Support both unix and windows paths
set runtimepath+=$HOME/.vim
set packpath+=$HOME/.vim
set viminfo+='1000,n~/.vim/viminfo
set history=1000

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" File manager
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git support
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" Auto completion and auto edit
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'tommcdo/vim-lion'
Plug 'tckmn/vim-minisnip'
Plug 'Shougo/echodoc.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'dkarter/bullets.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'noprompt/vim-yardoc'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Project support
Plug 'airblade/vim-rooter'
Plug 'editorconfig/editorconfig-vim'
Plug 'ludovicchabant/vim-gutentags'

" Syntax and Lint
Plug 'rodjek/vim-puppet'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'aklt/plantuml-syntax'

" Database
Plug 'kristijanhusak/vim-dadbod-ui'

" Diff
Plug 'ZSaberLv0/ZFVimDirDiff'

" Fun stuff
Plug 'mhinz/vim-startify'
Plug 'vim/killersheep'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Language, file encoding and format
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=en_US.UTF-8
let $LANG = 'en_US'
language en
set spelllang=en_us
set spellfile=$HOME/.vim/spell/en.utf8.add
set spell

" Order matters 
setglobal fileencoding=utf-8
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8
set termencoding=utf-8

" Favor Unix format
set fileformat=unix
set fileformats=unix,dos

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set guifont=Consolas:h11,Source_Code_Pro:h11,Hack:h11,Monospace:h11,Courier_New:h10
colorscheme bugi

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Files and directories
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set directory=~/.vim/tmp
set undodir=~/.vim/undofiles
set backupdir=~/.vim/backupfiles

" Do not use backup or swap files. Undo is enough
set undofile
set nobackup
set nowritebackup
set noswapfile
set autoread

" Pop up window confirmation on write or quit with changes
set confirm

" TextEdit might fail if hidden is not set.
set hidden

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Motion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable mouse
set mouse=""

" Disable mouse tool tips
set noballooneval

" Fix backspace
set backspace=indent,eol,start

" Squeeze spaces when using Lion
let g:lion_squeeze_spaces = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Find and replace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch
set incsearch
set magic

" Include files in current working directory
set path+=**

" Enable RipGrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --hidden\ --no-ignore\ -S
endif
if executable('fd')
  " Support for Puppet modules
  let g:gutentags_file_list_command = 'fd --type f . spec/fixtures/modules .' 
  command! -bang -nargs=? -complete=dir Files 
        \ call fzf#vim#files(<q-args>, {'source': 'fd --type f -I -H -E AppData -E .git -E .svn'}, <bang>0)
endif

let g:fzf_preview_window = []
let g:fzf_layout = { 'window': 'bo 10new' }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Diff mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set diffopt+=vertical
let g:ZFDirDiffFileExclude = "CVS,.git,.svn"
let g:ZFDirDiffShowSameFile = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Tabs and windows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set guitablabel=%t
set tabline=%t
set switchbuf=useopen,usetab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Text format
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set formatoptions+=jnM
set cindent
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set nojoinspaces

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Visual behavior
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number
set relativenumber

set list
set listchars=conceal:^,nbsp:+
set linebreak

set guioptions-=m
set guioptions-=T
set guioptions-=t
set guioptions-=r
set guioptions-=L
set guioptions+=c

set scrolloff=2
set sidescrolloff=5
set display+=lastline

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
let g:netrw_liststyle = 1
let g:netrw_sizestyle = 'H'
let g:netrw_silent = 1
let g:netrw_special_syntax = 1
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro rnu'
let g:netrw_use_errorwindow = 1

" Set default browser
" TODO: need to see netrw_filehandler
if has('win32')
  let g:netrw_browsex_viewer = 'start vieb'
else
  let g:netrw_browsex_viewer = 'xdg-open'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Auto completion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command line completion
set wildmenu
set wildmode=list:longest,full
set wildcharm=<Tab>
set noinfercase

if has('win32')
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Vim build-in completion
set completeopt=menu,popup,menuone,noinsert,noselect
set completepopup=border:off
set shortmess+=cm
set complete-=t
set complete-=i

let g:gutentags_cache_dir = '~/.vim/tags'
let g:gutentags_project_root_finder = 'FindGutentagsRootDirectory'

let g:minisnip_trigger = '<C-t>'

" View function parameters in pop up window
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'echo'

" Do not align hash rockets automatically for puppet
let g:puppet_align_hashes = 0

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
  autocmd BufFilePre,BufEnter,BufWinEnter *,!qf let &titlestring = ' ' . getcwd()

  " Set cursor at last position when opening files
  autocmd BufReadPost * 
        \ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " File type support
  autocmd FileType dosbatch,winbatch setlocal tabstop=4 shiftwidth=4
  autocmd BufNewFile,BufReadPost .vimlocal,.vimterm,.viebrc,vifmrc setlocal syntax=vim filetype=vim
  autocmd FileType ruby setlocal foldmethod=manual re=1 lazyredraw
  autocmd FileType yaml,xml,git,terminal,finished setlocal nospell

  " Quick fix window behavior
  autocmd QuickFixCmdPost [^l]* copen 10
  autocmd QuickFixCmdPost    l* lopen 10
  autocmd FileType qf wincmd J

  " Close hidden buffers for Netrw
  autocmd FileType netrw setlocal bufhidden=wipe

  " Easy escape on FZF
  autocmd FileType fzf tnoremap <ESC> <C-c>

  " Auto save
  autocmd CursorHold * 
        \ if &modified != 0 && bufname('%') != "" && 
        \ index(["terminal", "nofile", "finished"], &buftype) < 0 &&
        \ index(["gitcommit", "startify"], &filetype) < 0 |
        \   write |
        \ endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Syntax, Lint, Tests
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_config_home = '~/.vim/config'

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

" Display all lines with keyword under cursor and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

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
nnoremap <leader>c :Cmd cmd<CR>

" Remap wildmenu navigation
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" Switch between completion methods
imap <c-j> <plug>(MUcompleteCycFwd)
imap <c-k> <plug>(MUcompleteCycBwd)

" Copy file path to + register
nnoremap <leader>y :let @+=expand('%:p')<CR>

" FZF
nnoremap <C-p> :Files<CR>
nnoremap <C-h> :Buffers<CR>

" Jump to test file
nnoremap <leader>t :execute 'e ' findfile(b:testfile)<CR>

" Easy terminal jobs
command -nargs=* Cmd call RunTerminalCmd('cmd /c <args>')
command -nargs=* Bash call RunTerminalCmd('bash -lc "<args>"')
command -nargs=* R echo system('<args>')

" Test automation
nnoremap `t :RunProjectTest<CR>
nnoremap `a :RunAlternativeTest<CR>
nnoremap `f :RunFile<CR>
nnoremap `l :RunLastTest<CR>
nnoremap <leader>e /FAILED\\|ERROR\\|Error\\|Failed<CR>

" Terminal support
nnoremap <C-W>c <C-W>:tab term cmd /k clink inject<CR>
tnoremap <C-W>c <C-W>:tab term cmd /k clink inject<CR>
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

" Select function
vnoremap af :call VisualSelectFunction()<CR>

" To do list
abbreviate todo ~/notes.md

" Got through list of supported project
let projectDirectoryPath = 'c:\code'
command! -bang -nargs=? -complete=dir Proj
      \ call fzf#run(
      \ {
      \   'source': "fd --type d --max-depth 2 --full-path . \"" . projectDirectoryPath . '"',
      \   'sink': 'Ex',
      \   'window': 'bo 10new'
      \ }, <bang>0)
nnoremap <C-K> :Proj<CR>

" Re-size font
nnoremap <C-up> :silent! let &guifont = substitute(&guifont, ':h\zs\d\+', '\=eval(submatch(0)+1)', '')<CR>
nnoremap <C-down> :silent! let &guifont = substitute(&guifont, ':h\zs\d\+', '\=eval(submatch(0)-1)', '')<CR>

" Use TAB for COC completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackSpace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> <leader>[g <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

" Formatting selected code
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" Use CTRL-S for selections ranges.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Help and documentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Startup Screen
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set screen size for Startify to fit
set lines=37
set columns=110

let g:startify_lists = [
      \  { 'type': 'files', 'header': [' MRU'] },
      \  { 'type': 'bookmarks', 'header': [' Bookmarks'] },
      \]

let g:startify_skiplist = [
      \ escape(fnamemodify($HOME, ':p'), '\') .'AppData',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
      \ escape(fnamemodify($HOME, ':p'), '\') .'.vimrc',
      \]

let g:startify_bookmarks = [
      \  {'c': '~/.vimrc'}, 
      \  {'f': '~/.vimfm'},
      \  {'b': '~/.viebrc'},
      \  {'w': '~/Google Drive/Praca/wiki/wiki.md'}, 
      \  {'h': 'c:\Windows\System32\drivers\etc\hosts'}, 
      \  {'n': '~/notes.md'},
      \]

let g:startify_custom_header = [
      \ '        ________  ___  ___  ________  ___          ___      ___ ___  _____ ______       ',
      \ '       |\   __  \|\  \|\  \|\   ____\|\  \        |\  \    /  /|\  \|\   _ \  _   \     ',
      \ '       \ \  \|\ /\ \  \\\  \ \  \___|\ \  \       \ \  \  /  / | \  \ \  \\\__\ \  \    ', 
      \ '        \ \   __  \ \  \\\  \ \  \  __\ \  \       \ \  \/  / / \ \  \ \  \\|__| \  \   ',
      \ '         \ \  \|\  \ \  \\\  \ \  \|\  \ \  \       \ \    / /   \ \  \ \  \    \ \  \  ',
      \ '          \ \_______\ \_______\ \_______\ \__\       \ \__/ /     \ \__\ \__\    \ \__\ ',
      \ '           \|_______|\|_______|\|_______|\|__|        \|__|/       \|__|\|__|     \|__| ',
      \ '',
      \ '                                           Vim ' . v:versionlong,
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
set statusline+=\ [Syntax(%{coc#status()}%{get(b:,'coc_current_function','')})]
set statusline+=\ [GT\ %{gutentags#statusline()}]

" Source local changes. They are either OS or project specific and should not be in repository
source $HOME/.vimlocal
