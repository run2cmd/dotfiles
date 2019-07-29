" ~/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Defaults
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype plugin indent on

source $VIMRUNTIME/vimrc_example.vim

source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set noerrorbells visualbell t_vb=

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Language, file encoding and format
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=en_US.UTF-8
let $LANG = 'en_US'
if has("win32")
  language en
endif
set spelllang=en_us

setglobal fileencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8
set termencoding=utf-8

set fileformat=unix
set fileformats=unix,dos

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Files and directories
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=$HOME/.vim
" TODO: add automatic doc generation
set packpath+=$HOME/.vim
" TODO: Probobly needs to delete backup and temp dirs
set directory=~/.vim/tmp
set backupdir=~/.vim/backup
set viminfo+='1000,n~/.vim/viminfo
set undodir=~/.vim/undofiles
set path+=**

set undofile
set history=1000

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set background=dark
set guifont=Consolas:h10,Source_Code_Pro:h11,Hack:h11,Monospace:h11,Courier_New:h10
colorscheme bugi

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: File opertaions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoread
set lazyredraw
set confirm

if has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Movement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: Jump between functions: if,else,do,end,{},(), etc. Both in normal and visual mode
" jump to the previous function
set mouse=""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Search and replace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch
set incsearch
set magic

" Enable The Silver Searcher (AG)
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Search on visual selection
function! VisualSelection() range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" TODO: Write function to load grep into arglist for project code refactoring
":grep accounting::install manifests\*.pp spec\defines\**\*_spec.rb spec\classes\**\*_spec.rb
":cdo %s/myclass::permit/myclass::params/ge | update
"function! ReplaceOnVisual() range
"endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Secion: Diff options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set diffopt=vertical,internal,filler

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Tabs and windows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabpagemax=50
set guitablabel=%F
set tabline=%F
set switchbuf=useopen,usetab
set splitright

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Text format
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set textwidth=100
set backspace=indent,eol,start
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set formatoptions+=j
set lbr

set smartindent
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab

set nojoinspaces

" Pretty indention look
let g:indentLine_char = '┊'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Visual behavior
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number

set guioptions-=m
set guioptions-=T
set guioptions-=t
set guioptions-=r
set guioptions-=L

set scrolloff=2
set sidescrolloff=5
set display+=lastline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Performance
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=250

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Workspace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rooter_silent_chdir = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Custom Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcAuCmd
  autocmd!

  " Disable bell and blink 
  autocmd GUIEnter * set visualbell t_vb=
  autocmd BufEnter * :syntax sync fromstart

  " Set cursor at last position when opening files
  autocmd BufReadPost * 
  \ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " Convert path to Unix for WSL support
  if has('win32')
    autocmd BufWinEnter * let b:unix_path = substitute(expand('%'), '\', '/', 'g')
  else
    let b:unix_path = expand('%')
  endif

  " Filetype support
  autocmd BufWinEnter *_spec.rb 
  \ let b:dispatch = "bash.exe -lc 'rspec --format progress " . b:unix_path . "'"
  autocmd Filetype python setlocal tabstop=4 shiftwidth=4
  autocmd FileType groovy setlocal tabstop=4 shiftwidth=4
  autocmd FileType groovy let b:dispatch = 'gradlew clean test build --info'
  autocmd FileType java setlocal tabstop=4 shiftwidth=4
  autocmd FileType Jenkinsfile setlocal tabstop=4 shiftwidth=4
  autocmd FileType Jenkinsfile 
  \ let b:dispatch = "type % | plink -batch -load jenkins-lint declarative-linter"
  autocmd FileType xml
  \ setlocal tabstop=4 shiftwidth=4 syntax=xml filetype=xml textwidth=500
  \ let b:dispatch = 'mvn clean install -f % -DskipTests'
  autocmd FileType markdown setlocal spell 
  autocmd FileType gitcommit setlocal tw=72
  autocmd FileType dosbatch,winbatch setlocal tabstop=4 shiftwidth=4
  autocmd Filetype yaml setlocal syntax=yaml filetype=yaml textwidth=220
  autocmd BufWinEnter yaml let b:dispatch = "bash.exe -lc 'ansible-lint " . b:unix_path . "'"
  autocmd BufNewFile,BufReadPost Gemfile* setlocal filetype=ruby syntax=ruby
  autocmd BufNewFile,BufReadPost *.todo setlocal textwidth=1000 spell
  autocmd BufNewFile,BufReadPost *Vagrantfile* setlocal syntax=ruby filetype=ruby
  autocmd BufNewFile,BufReadPost *.gradle setlocal syntax=groovy filetype=groovy
  autocmd Filetype uml,plantuml,pu let b:dispatch = 'plantuml %'

  " Quickfix window behavior
  autocmd QuickFixCmdPost [^l]* copen 10
  autocmd QuickFixCmdPost    l* lopen 10
  autocmd FileType qf wincmd J
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: File Explorer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_fastbrowse     = 0
let g:netrw_banner         = 0
let g:netrw_preview        = 1
let g:netrw_winsize        = 25
let g:netrw_altv           = 1
let g:netrw_fastbrowse     = 2
let g:netrw_keepdir        = 0
let g:netrw_liststyle      = 1
let g:netrw_retmap         = 1
let g:netrw_silent         = 1
let g:netrw_special_syntax = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Autocompletion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: Needs autocompletion to:
"   1. Show completeion on class/definition when new line starts (or after
"      include/class/define, etc)
"   2. Need to look for words in else conditions
"
set wildmenu

set omnifunc=ale#completion#OmniFunc
set completeopt+=longest,menuone,noinsert,noselect
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowAccess = 1
set shortmess+=cm

set complete-=i
set complete-=t

let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#chains = {
\ 'default' : ['path', 'omni', 'keyn', 'keyp', 'c-n', 'c-p', 'uspl', 'tags' ],
\ 'vim' : [ 'path', 'cmd', 'keyn', 'keyp' ],
\ 'puppet' : [ 'path', 'omni', 'keyn', 'keyp', 'tags', 'c-n', 'c-p', 'uspl', 'ulti' ],
\ 'python' : [ 'path', 'omni', 'keyn', 'keyp', 'c-n', 'c-p', 'uspl', 'ulti', 'tags' ],
\ 'ruby' : [ 'path', 'omni', 'keyn', 'keyp', 'c-n', 'c-p', 'uspl', 'ulti', 'tags' ],
\ 'markdown' : [ 'keyn', 'keyp', 'c-n', 'c-p' ],
\ }

let g:gutentags_cache_dir = '~/.vim/tags'
let g:gutentags_exclude_project_root = ['fixtures']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: FuzzyFinder and MRU
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:30'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
\ 'dir':  '\.git$\|\.svn$\|\.hg$\|\.yardoc$\|node_modules\|spec\\fixtures\\modules$',
\ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Syntaxt and Lint
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: Puppet syntax check using puppet command doest not works for END lines. Reported BUG to ALE.
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_echo_msg_format = '[%linter%][%severity%][%code%] %s'
let g:ale_python_flake8_options = '--ignore=E501'
let g:ale_eruby_erubylint_options = "-T '-'"
if has("win32")
  let g:ale_ruby_rubocop_options = '-c %USERPROFILE%\.rubocop.yaml'
else
  let g:ale_ruby_rubocop_options = '-c ~/.rubocop.yaml'
endif

" Custom Ale Linter in status line
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(
  \ '%dW %dE',
  \ all_non_errors,
  \ all_errors
  \)
endfunction

let g:ale_fixers = {
\ 'puppet': ['puppetlint', 'trim_whitespace', 'remove_trailing_lines'],
\ 'ruby': ['rubocop', 'trim_whitespace', 'remove_trailing_lines'],
\ 'python': [
\   'autopep8', 'isort', 'add_blank_lines_for_python_control_statements',
\   'trim_whitespace', 'remove_trailing_lines'
\ ],
\ 'yaml': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\ 'markdown': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\}

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <Up>    <C-W><C-K>
nnoremap <Down>  <C-W><C-J>
nnoremap <Left>  <C-W><C-H>
nnoremap <Right> <C-W><C-L>

" Clear search and diff
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

nnoremap <C-K> :tabnew<CR>
nnoremap <C-Tab> :tabnext<CR>
nnoremap <C-S-Tab> :tabprevious<CR>

nnoremap <F7> :Dispatch<CR>

nnoremap <C-y> :CtrlPYankring<CR>
nnoremap <C-h> :CtrlPBuffer<CR>

"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Statusline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
set statusline=
set statusline+=%#StatusLine#
set statusline+=%<[%{FugitiveHead()}]
set statusline+=%#StatusLineNC#
set statusline+=\ %y[%{&ff}]
set statusline+=[%{strlen(&fenc)?&fenc:&enc}a]
set statusline+=\ %h%m%r%w
set statusline+=%#TabLineSel#
set statusline+=\ [Ale(%{LinterStatus()})]
set statusline+=%#StatusLineNC#
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %p%%
set statusline+=\ %l:%c

