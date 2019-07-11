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

"
" Section: Colors and Fonts
" 
syntax on
set background=dark
set guifont=Consolas:h10,Source_Code_Pro:h11,Hack:h11,Monospace:h11
colorscheme bugi

" 
" Section: File opertaions
"
set autoread
set lazyredraw
set confirm

if has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"
" Section: Search and replace
"
set hlsearch
set incsearch
set magic

"
" Secion: Diff options
"
set diffopt=vertical,internal,filler

"
" Section: Tabs
"
set tabpagemax=50
set guitablabel=%F
set tabline=%F
set switchbuf=useopen,usetab

"
" Section: Text format
"
set textwidth=80
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

"
" Section: Autocompletion
"
set omnifunc=ale#completion#OmniFunc
set completeopt+=longest,menuone,noinsert,noselect
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_DisplayMode = 1
let OmniCpp_ShowAccess = 1
set shortmess+=c

set complete-=i
set complete-=t

"
" Section: The Silver Searcher (AG)
" 
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

"
" Section: Visual behavior
"
set number

set guioptions-=m
set guioptions-=T
set guioptions-=t
set guioptions-=r
set guioptions-=L

set scrolloff=2
set sidescrolloff=5
set display+=lastline

"
" Section: Performance
"
set updatetime=250

"
" Section: Keybindings
"
let mapleader = ","

map <leader>ba :bufdo bd<cr>

nnoremap <Up>    <C-W><C-K>
nnoremap <Down>  <C-W><C-J>
nnoremap <Left>  <C-W><C-H>
nnoremap <Right> <C-W><C-L>

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

nnoremap <C-K> :tabnew<CR>
nnoremap <C-Tab> :tabnext<CR>
nnoremap <C-S-Tab> :tabprevious<CR>

" Find word in root
nnoremap <C-S> :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" ViFM Explorer
nnoremap <F6> :edit %:p:h<CR>

" 
" Section: Custom Autocommands
"
augroup vimrcAuCmd
  autocmd!

  autocmd GUIEnter * set visualbell t_vb=
  autocmd BufEnter * :syntax sync fromstart

  " Set cursor at last position when opening files
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " vim-dispatch auto commands
  autocmd BufWinEnter * let b:unix_path = substitute(expand('%'), '\', '/', 'g')
  autocmd BufWinEnter *_spec.rb let b:dispatch = "bash.exe -lc 'rspec --format progress " . b:unix_path . "'"
  autocmd Filetype groovy let b:dispatch = 'gradlew clean test build --info'
  autocmd Filetype xml let b:dispatch = 'mvn clean install -f % -DskipTests'
  autocmd Filetype uml,plantuml,pu let b:dispatch = 'plantuml %'
  autocmd Filetype *.yaml,*.yml let b:dispatch = "bash.exe -lc 'ansible-lint " . b:unix_path . "'"
  autocmd Filetype Jenkinsfile let b:dispatch = "type % | plink -batch -load jenkins-lint declarative-linter"

  " Quickfix window behavior
  autocmd QuickFixCmdPost [^l]* copen 10
  autocmd QuickFixCmdPost    l* lopen 10
  autocmd FileType qf wincmd J

  " Filetype support
  autocmd BufNewFile,BufReadPost *.rb setlocal tabstop=2 shiftwidth=2
  autocmd BufNewFile,BufReadPost Gemfile* setlocal tabstop=2 shiftwidth=2 filetype=ruby syntax=ruby
  autocmd BufNewFile,BufReadPost *.todo setlocal textwidth=1000 spell
  autocmd BufNewFile,BufReadPost *Jenkinsfile* setlocal tabstop=4 shiftwidth=4 syntax=groovy filetype=groovy
  autocmd BufNewFile,BufReadPost *Vagrantfile* setlocal tabstop=2 shiftwidth=2 syntax=ruby filetype=ruby
  autocmd BufNewFile,BufReadPost *.xml setlocal tabstop=4 shiftwidth=4 syntax=xml filetype=xml textwidth=500
  autocmd BufNewFile,BufReadPost *.groovy setlocal tabstop=4 shiftwidth=4 syntax=groovy filetype=groovy
  autocmd BufNewFile,BufReadPost *.gradle setlocal tabstop=4 shiftwidth=4 syntax=groovy filetype=groovy
  autocmd BufNewFile,BufReadPost *.yaml,*.yml setlocal tabstop=2 shiftwidth=2 syntax=yaml filetype=yaml textwidth=220
  autocmd BufNewFile,BufReadPost *.bat setlocal tabstop=2 shiftwidth=2 ff=dos
  autocmd BufNewFile,BufReadPost *.md setlocal spell
augroup END

"
" Section: Netrw 
"
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
nnoremap <C-h> :CtrlPBuffer<CR>

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
nnoremap <F7> :Dispatch<CR>

"
" Section: indentLine
"
let g:indentLine_char = '┊'

"
" Section: Statusline
"
set wildmenu
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

" 
" Section: Movement and Select
"
" TODO: Jump between functions: if,else,do,end,{},(), etc. Both in normal and visual mode


"
" Section: Search on visual selection
"
vnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>
function! VisualSelection() range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
