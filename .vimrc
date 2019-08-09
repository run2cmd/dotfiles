" Maintainer: Piotr Bugała <https://github.com/run2cmd>
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Defaults
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype plugin indent on

source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set noerrorbells visualbell t_vb=

set runtimepath+=$HOME/.vim
set packpath+=$HOME/.vim
set viminfo+='1000,n~/.vim/viminfo
set history=1000

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Language, file encoding and format
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=en_US.UTF-8
let $LANG = 'en_US'
if has('win32')
  language en
endif
set spelllang=en_us

" Order matters 
setglobal fileencoding=utf-8
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8
set termencoding=utf-8

set fileformat=unix
set fileformats=unix,dos

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set background=dark
set guifont=Consolas:h10,Source_Code_Pro:h11,Hack:h11,Monospace:h11,Courier_New:h10
colorscheme bugi

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Files and directories
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set directory=~/.vim/tmp
set undodir=~/.vim/undofiles
set path+=**

set undofile
set nobackup
set autoread
set confirm

if has('win32')
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Movement
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set backspace=indent,eol,start
set mouse=""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Find and replace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch
set incsearch
set magic

" Enable The Silver Searcher (AG)
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:30'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.svn$\|\.hg$\|\.yardoc$\|node_modules\|spec\\fixtures\\modules$',
      \}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Secion: Diff mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set diffopt=vertical,internal,filler

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Tabs and windows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabpagemax=50
set guitablabel=%F
set tabline=%F
set switchbuf=useopen,usetab
set noequalalways

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Text format
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set textwidth=100
set formatoptions+=jn
set formatoptions-=o
" TODO: set proper formatting options per filetype to enable automatic formatting
" set formatoptions+=a

set smartindent
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set nojoinspaces

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Visual behavior
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set lazyredraw
set number

set list
set listchars=trail:-,conceal:^,nbsp:+
set linebreak

set guioptions-=m
set guioptions-=T
set guioptions-=t
set guioptions-=r
set guioptions-=L

set scrolloff=2
set sidescrolloff=5
set display+=lastline

set lines=37
set columns=100

let g:indentLine_char = '┊'
let g:indentLine_fileTypeExclude = ['startify', 'markdown']
let g:indentLine_bufTypeExclude = ['terminal', 'help', 'quickfix' ]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Performance
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=250

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Custom Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcAuCmd
  autocmd!

  " Automatic doc generation for vim modules
  autocmd VimEnter :helptags ALL

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
  autocmd FileType ruby setlocal re=1

  "TODO: Fix DoGe pattern for Puppet. Put ticket for DoGe
  "autocmd FileType puppet let b:doge_patterns = {}
  autocmd BufWinEnter *_spec.rb 
        \ let b:dispatch = "bash.exe -lc 'rspec --format progress " . b:unix_path . "'"
  autocmd Filetype python setlocal tabstop=4 shiftwidth=4
  autocmd FileType groovy setlocal tabstop=4 shiftwidth=4
  autocmd FileType groovy let b:dispatch = 'gradlew clean test build --info'
  autocmd FileType java setlocal tabstop=4 shiftwidth=4
  autocmd FileType Jenkinsfile setlocal tabstop=4 shiftwidth=4
  autocmd FileType Jenkinsfile 
        \ let b:dispatch = "type % | plink -batch -load jenkins-lint declarative-linter"
  autocmd FileType xml setlocal tabstop=4 shiftwidth=4 syntax=xml filetype=xml textwidth=500
  autocmd FileType xml let b:dispatch = 'mvn clean install -f % -DskipTests'
  autocmd FileType markdown setlocal spell 
  autocmd FileType gitcommit setlocal tw=72
  autocmd FileType dosbatch,winbatch setlocal tabstop=4 shiftwidth=4
  autocmd Filetype yaml setlocal syntax=yaml filetype=yaml textwidth=220
  autocmd BufWinEnter yaml let b:dispatch = "bash.exe -lc 'ansible-lint " . b:unix_path . "'"
  autocmd BufNewFile,BufReadPost Gemfile* setlocal filetype=ruby syntax=ruby re=1
  autocmd BufNewFile,BufReadPost *.todo setlocal textwidth=1000 spell
  autocmd BufNewFile,BufReadPost *Vagrantfile* setlocal syntax=ruby filetype=ruby re=1
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
" TODO: completion method features:
" - react on keywords (include, contain, require, etc)
" - methods completion
"
set wildmenu

set omnifunc=ale#completion#OmniFunc
set completeopt+=longest,menuone,noinsert,noselect
set shortmess+=cm
set complete-=i
set complete-=t

let g:gutentags_cache_dir = '~/.vim/tags'
let g:gutentags_file_list_command = { 'markers': { '.git': 'git ls-files' } }
let g:gutentags_exclude_project_root = ['fixtures', 'coverage', '.yardoc']

let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#chains = {
      \  'default' : ['path', 'omni', 'c-n', 'tags' ],
      \  'vim' : [ 'path', 'cmd', 'c-n' ],
      \  'puppet' : [ 'path', 'omni', 'c-n', 'tags' ],
      \  'python' : [ 'path', 'omni', 'c-n', 'tags' ],
      \  'ruby' : [ 'path', 'omni', 'c-n',  'tags' ],
      \  'markdown' : [ 'keyn', 'c-n', 'tags' ],
      \}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Syntaxt and Lint
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: Puppet syntax check using puppet command doest not works for END lines. Reported BUG to ALE.
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_echo_msg_format = '[%linter%][%severity%][%code%] %s'
let g:ale_python_flake8_options = '--ignore=E501'
let g:ale_eruby_erubylint_options = "-T '-'"
if has('win32')
  let g:ale_ruby_rubocop_options = '-c %USERPROFILE%\.rubocop.yaml'
else
  let g:ale_ruby_rubocop_options = '-c ~/.rubocop.yaml'
endif

let g:ale_fixers = {
      \  'puppet': ['puppetlint', 'trim_whitespace', 'remove_trailing_lines'],
      \  'ruby': ['rubocop', 'trim_whitespace', 'remove_trailing_lines'],
      \  'python': [
      \    'autopep8', 'isort', 'add_blank_lines_for_python_control_statements',
      \    'trim_whitespace', 'remove_trailing_lines'
      \  ],
      \  'yaml': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
      \  'markdown': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
      \}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ','

map <leader>db :bufdo bd<CR>

" Display all lines with keyword under cursor and ask which one to jump to
nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

nnoremap <Up>    <C-W><C-K>
nnoremap <Down>  <C-W><C-J>
nnoremap <Left>  <C-W><C-H>
nnoremap <Right> <C-W><C-L>

" Clear search and diff
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

nnoremap <leader>o :tabnew<Bar>Startify<CR>
nnoremap <C-Tab> :tabnext<CR>
nnoremap <C-S-Tab> :tabprevious<CR>

nnoremap <F7> :Dispatch<CR>

nnoremap <C-y> :CtrlPYankring<CR>
nnoremap <C-h> :CtrlPBuffer<CR>

" Repeat in visual mode
vnoremap . :normal .<CR>

" Terminal helper to open on the bottom
nnoremap <leader>t :bo term<CR><C-W>:res 10<CR>

" Find word under cursor in CWD recursively
nnoremap <C-S> :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Search on visual selection
vnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>

" Search tasks in current file
nnoremap <leader>s :silent Ggrep "TODO\\|FIXME"<CR>

" Switch between completion methods
imap <c-j> <plug>(MUcompleteCycFwd)
imap <c-k> <plug>(MUcompleteCycBwd)

let g:doge_mapping_comment_jump_forward = '<Leader>n'
let g:doge_mapping_comment_jump_backward = '<Leader>p'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Help and documentation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Project workspace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rooter_silent_chdir = 1
let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']
let g:projectionist_heuristics = {
      \ '*': {
      \   'manifests/*.pp': { 
      \     'alternate': [
      \       'spec/classes/{}_spec.rb', 
      \       'spec/defines/{}_spec.rb', 
      \     ],
      \     'type': 'source' 
      \   },
      \   'spec/defines/*_spec.rb': { 'alternate': 'manifests/{}.pp', 'type': 'rspec' },
      \   'spec/classes/*_spec.rb': { 'alternate': 'manifests/{}.pp', 'type': 'rspec' },
      \   'spec/acceptance/*_spec.rb': { 'type': 'accept' },
      \  }
      \}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Startup Screen
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_lists = [
      \  { 'type': 'files', 'header': [' MRU'] },
      \  { 'type': 'bookmarks', 'header': [' Bookmarks'] },
      \]

let g:startify_skiplist = [
      \ escape(fnamemodify($HOME, ':p'), '\') .'AppData',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
      \ escape(fnamemodify($HOME, ':p'), '\') .'.vim\\pack',
      \]

let g:startify_bookmarks = [
      \  {'c': '~/.vimrc'}, 
      \  {'w': '~/Google Drive/Praca/wiki/wiki.md'}, 
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
" Section: Statusline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MUCompleteStatusLine()
  return get(g:mucomplete#msg#short_methods, get(g:, 'mucomplete_current_method', ''), '')
endf

function! ALELinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(
        \  '%dW %dE',
        \  all_non_errors,
        \  all_errors
        \)
endfunction

set laststatus=2
set statusline=
set statusline+=%#StatusLine#
set statusline+=%<[%{FugitiveHead()}]
set statusline+=%#StatusLineNC#
set statusline+=\ %y[%{&ff}]
set statusline+=[%{strlen(&fenc)?&fenc:&enc}a]
set statusline+=\ %h%m%r%w
set statusline+=%#TabLineSel#
set statusline+=\ [Ale(%{ALELinterStatus()})]
set statusline+=%#StatusLineNC#
set statusline+=%=
set statusline+=[MU\ %{MUCompleteStatusLine()}]
set statusline+=\ [GT\ %{gutentags#statusline()}]
set statusline+=%#CursorColumn#
set statusline+=\ %p%%
set statusline+=\ %l:%c
