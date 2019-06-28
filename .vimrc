" ~/.vimrc

"
" Section: Defaults
"
set nocompatible
filetype plugin indent on

source $VIMRUNTIME/vimrc_example.vim

source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

"
" Section: Language, file encoding and format
"
set langmenu=en_US.UTF-8
let $LANG = 'en_US'
if has("win32")
  language en
endif

setglobal fileencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8
set termencoding=utf-8

set fileformat=unix
set fileformats=unix,dos


"
" Section: Files and directories
" 
set rtp+=$HOME/.vim
set packpath+=$HOME/.vim
set directory=~/.vim/tmp
set backupdir=~/.vim/backup
set viminfo+='1000,n~/.vim/viminfo
set undodir=~/.vim/undofiles
set path+=**

"
" Section: Colors and Fonts
" 
syntax on
set background=dark
set guifont=Consolas:h10
colorscheme bugi

" 
" Section: File opertaions
"
set autoread
set lazyredraw
set confirm

"
" Section: Search and replace
"
set hlsearch
set incsearch

"
" Section: Tabs
"
set tabpagemax=50
set guitablabel=%F
set tabline=%F

"
" Section: Text format
"

set history=1000
set textwidth=220
set backspace=indent,eol,start
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set formatoptions+=j

set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

autocmd BufEnter * :syntax sync fromstart

"
" Section: Autocompletion
"
set omnifunc=syntaxcomplete#Complete
set completeopt+=longest,menuone,noinsert,noselect
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowAccess = 1
set shortmess+=c

set complete-=i
set complete-=t

"
" Section: Visual behavior
"
set number

set guioptions-=m
set guioptions-=T
set guioptions-=t
set guioptions-=r
set guioptions-=L

set scrolloff=1
set sidescrolloff=5
set display+=lastline

"
" Section: Performance
"
set updatetime=250

"
" Section: Keybindings
"
nnoremap <Up>    <C-W><C-K>
nnoremap <Down>  <C-W><C-J>
nnoremap <Left>  <C-W><C-H>
nnoremap <Right> <C-W><C-L>

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

nnoremap <C-X> :tabnew<CR>
nnoremap <C-Tab> :tabnext<CR>
nnoremap <C-S-Tab> :tabprevious<CR>

autocmd QuickFixCmdPost [^l]* copen 10
autocmd QuickFixCmdPost    l* lopen 10

" ViFM Explorer
nnoremap <F6> :edit %:p:h<CR>

"
" Section: Netrw 
"nnoremap tf :Explore<CR>
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


"
" Section: MUcomplete
"
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#chains = {
      \ 'default' : ['path', 'omni', 'keyn', 'keyp', 'c-n', 'c-p', 'uspl', 'tags' ],
      \ 'vim' : [ 'path', 'cmd', 'keyn', 'keyp' ],
      \ 'puppet' : [ 'path', 'omni', 'keyn', 'keyp', 'tags', 'c-n', 'c-p', 'uspl', 'ulti' ],
      \ 'python' : [ 'path', 'omni', 'keyn', 'keyp', 'c-n', 'c-p', 'uspl', 'ulti', 'tags' ],
      \ 'ruby' : [ 'path', 'omni', 'keyn', 'keyp', 'c-n', 'c-p', 'uspl', 'ulti', 'tags' ],
      \ }

" 
" Section: CtrlP
"
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:30'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
\ 'dir':  '\.git$\|\.svn$\|\.hg$\|\.yardoc$\|node_modules\|spec\\fixtures\\modules$',
\ }
nnoremap <C-y> :CtrlPYankring<CR>

" 
" Section: Ale checker
"
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

nmap <silent> gj <Plug>(ale_previous_wrap)
nmap <silent> gk <Plug>(ale_next_wrap)

" Custom Ale Linter in status line
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(
  \   '%dW %dE',
  \   all_non_errors,
  \   all_errors
  \)
endfunction

let g:ale_fixers = {
\   'puppet': ['puppetlint', 'trim_whitespace', 'remove_trailing_lines'],
\   'ruby': ['rubocop', 'trim_whitespace', 'remove_trailing_lines'],
\   'python': ['autopep8', 'isort', 'add_blank_lines_for_python_control_statements', 'trim_whitespace', 'remove_trailing_lines'],
\   'yaml': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\   'markdown': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\}

"
" Section: vim-markdown
"
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0

"
" Section: GutenTags
"
let g:gutentags_cache_dir = '~/.vim/tags'
let g:gutentags_exclude_project_root = ['fixtures']

" 
" Section: vim-rooter
"
let g:rooter_silent_chdir = 1


" 
" Section: easyalign
"
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


"
" Section: vim-dispatch
"
autocmd BufWinEnter * let b:unix_path = substitute(expand('%'), '\', '/', 'g')
autocmd BufWinEnter *_spec.rb let b:dispatch = "bash.exe -lc 'rspec " . b:unix_path . "'"
autocmd Filetype groovy let b:dispatch = 'gradlew clean test build --info'
autocmd Filetype xml let b:dispatch = 'mvn clean install -f % -DskipTests'
autocmd Filetype uml,plantuml,pu let b:dispatch = 'plantuml %'
autocmd BufWinEnter *.yaml,*.yml let b:dispatch = "bash.exe -lc 'ansible-lint " . b:unix_path . "'"
autocmd BufNewFile,BufReadPost Jenkinsfile let b:dispatch = "type % | plink -batch -load jenkins-lint declarative-linter"

nnoremap <F7> :Dispatch<CR>

autocmd FileType qf wincmd J

"
" Section: indentLine
"
let g:indentLine_char = '┊'

"
" Section: Filetype support
"
autocmd BufNewFile,BufReadPost *.rb setlocal tabstop=2 shiftwidth=2
autocmd BufNewFile,BufReadPost Gemfile* setlocal tabstop=2 shiftwidth=2 filetype=ruby syntax=ruby
autocmd BufNewFile,BufReadPost *.todo setlocal textwidth=1000
autocmd BufNewFile,BufReadPost *Jenkinsfile* setlocal tabstop=4 shiftwidth=4 syntax=groovy filetype=groovy
autocmd BufNewFile,BufReadPost *Vagrantfile* setlocal tabstop=2 shiftwidth=2 syntax=ruby filetype=ruby
autocmd BufNewFile,BufReadPost *.xml setlocal tabstop=2 shiftwidth=2 syntax=xml filetype=xml
autocmd BufNewFile,BufReadPost *.groovy setlocal tabstop=4 shiftwidth=4 syntax=groovy filetype=groovy
autocmd BufNewFile,BufReadPost *.gradle setlocal tabstop=4 shiftwidth=4 syntax=groovy filetype=groovy
autocmd BufNewFile,BufReadPost *.yaml setlocal tabstop=2 shiftwidth=2 syntax=yaml filetype=yaml
autocmd BufNewFile,BufReadPost *.yml setlocal tabstop=2 shiftwidth=2 syntax=yaml filetype=yaml
autocmd BufNewFile,BufReadPost *.bat setlocal tabstop=2 shiftwidth=2 ff=dos
autocmd BufNewFile,BufReadPost *.md setlocal textwidth=80

"
" Section: Statusline
"
set wildmenu
set laststatus=2
set statusline=
set statusline+=%F\ %y[%{&ff}]
set statusline+=[%{strlen(&fenc)?&fenc:&enc}a]
set statusline+=\ %h%m%r%w
set statusline+=\ [Ale(%{LinterStatus()})]
set statusline+=%<\ %{fugitive#statusline()}
