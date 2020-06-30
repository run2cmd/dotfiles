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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Defaults
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype plugin indent on

" Load VIM defaults
source $VIMRUNTIME/vimrc_example.vim

" No sounds
set noerrorbells visualbell t_vb=

" Support both unix and windows paths
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

" Favor unix format
set fileformat=unix
set fileformats=unix,dos

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set background=dark
set guifont=Consolas:h11,Source_Code_Pro:h11,Hack:h11,Monospace:h11,Courier_New:h10
colorscheme bugi

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Files and directories
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set directory=~/.vim/tmp
set undodir=~/.vim/undofiles

" Do not use backup or swapfiles. Undo is enough
set undofile
set nobackup
set noswapfile
set autoread

" Popup confirmation on write or quit with changes
set confirm

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Motion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable mouse
set mouse=""
set noballooneval

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Find and replace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch
set incsearch
set magic

" Include files in CWD
set path+=**

" Enable The Silver Searcher (AG)
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Secion: Diff mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set diffopt+=vertical
let g:DirDiffExcludes = "CVS,*.class,*.exe,.*.swp,.git,.svn"

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
set formatoptions-=o

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

set scrolloff=2
set sidescrolloff=5
set display+=lastline

let g:indentLine_char = '┊'
let g:indentLine_fileTypeExclude = ['startify', 'markdown']
let g:indentLine_bufTypeExclude = ['terminal', 'help', 'quickfix' ]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: File Explorer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

if has('win32')
  let g:netrw_browsex_viewer = 'start chrome.exe'
else
  let g:netrw_browsex_viewer = 'xdg-open'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Autocompletion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu
set wildmode=list:longest,full
set wildcharm=<Tab>
set completeopt=menu,preview,longest,menuone,noinsert,noselect
set shortmess+=cm
set complete-=t
set complete-=i

if has('win32')
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Enable ALE LSP completion 
set omnifunc=ale#completion#OmniFunc

" Exclude artifacts and dependencies from :Ggrep
if has('win32') 
  let gitls = 'scripts\tag_file_list.bat'
else
  let gitls = 'git ls-files && find . -type f spec/fixtures/modules -name *.pp' 
endif

let g:gutentags_cache_dir = '~/.vim/tags'

" Dummy function to use vim-rooter settings for tags generation
function FindGutentagsRootDirectory(path)
  return FindRootDirectory()
endf

let g:gutentags_project_root_finder = 'FindGutentagsRootDirectory'

let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#chains = {
      \  'default' : ['path', 'omni', 'c-n', 'keyn', 'tags'],
      \  'vim' : ['path', 'omni', 'cmd', 'c-n', 'keyn'],
      \  'markdown' : ['keyn', 'c-n', 'keyn'],
      \}

let g:minisnip_trigger = '<C-t>'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Project workspace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rooter_silent_chdir = 1
let g:rooter_excludes = ['fixtures']
let g:startify_change_to_dir = 0
let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']

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

  " Set titlestring
  autocmd BufEnter,BufWinEnter * let &titlestring = ' ' . getcwd()

  " Set cursor at last position when opening files
  autocmd BufReadPost * 
        \ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " Filetype support
  autocmd FileType gitcommit setlocal tw=72
  autocmd FileType dosbatch,winbatch setlocal tabstop=4 shiftwidth=4
  autocmd Filetype uml,plantuml,pu let b:dispatch = 'plantuml %'
  autocmd BufNewFile,BufReadPost Gemfile* setlocal filetype=ruby syntax=ruby re=1
  autocmd BufNewFile,BufReadPost *.todo setlocal textwidth=1000 spell
  autocmd BufNewFile,BufReadPost *Vagrantfile* setlocal syntax=ruby filetype=ruby re=1
  autocmd BufNewFile,BufReadPost *.gradle setlocal syntax=groovy filetype=groovy

  " Ansible support
  autocmd BufNewFile,BufReadPost *.{yaml,yml}
        \ for strMatch in ["- hosts:", "- name:", "- tasks"] |
        \   if match(readfile(expand('%:p')), strMatch) > -1 | 
        \     setlocal filetype=ansible syntax=yaml | 
        \     break |
        \   endif |
        \ endfor

  " Quickfix window behavior
  autocmd QuickFixCmdPost [^l]* copen 10
  autocmd QuickFixCmdPost    l* lopen 10
  autocmd FileType qf wincmd J

  " Quickly jump through project files
  autocmd BufWinLeave *.gradle,*.xml mark P
  autocmd BufWinLeave Jenkinsfile mark J
  autocmd BufWinleave *.md,*.markdown mark D

  " Close hidden buffers for Netrw
  autocmd FileType netrw setlocal bufhidden=wipe

  " Autosave
  autocmd CursorHold * if &modified != 0 && &buftype != "terminal" | write | endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Syntaxt and Lint
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_hover_to_preview = 1
let g:ale_echo_msg_format = '[%linter%][%severity%][%code%] %s'
let g:ale_python_flake8_options = '--ignore=E501'
let g:ale_eruby_erubylint_options = "-T '-'"
if has('win32')
  let g:ale_ruby_rubocop_options = '-c %USERPROFILE%\.rubocop.yaml'
  let g:ale_yaml_yamllint_options = '-c %USERPROFILE%\.yamllint'
else
  let g:ale_ruby_rubocop_options = '-c ~/.rubocop.yaml'
  let g:ale_yaml_yamllint_options = '-c ~/.yamllint'
endif
let g:ale_sh_shellcheck_options = '-e SC2086' 

" Enable pyls for Python
let g:ale_linters = { 'python': ['pylint', 'pyls'] }

let g:ale_fixers = {
      \  'puppet': ['puppetlint', 'trim_whitespace', 'remove_trailing_lines'],
      \  'ruby': ['rubocop', 'trim_whitespace', 'remove_trailing_lines'],
      \  'python': [
      \    'autopep8', 'isort', 'add_blank_lines_for_python_control_statements',
      \    'trim_whitespace', 'remove_trailing_lines'
      \  ],
      \  'yaml': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
      \  'markdown': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
      \  '*': ['trim_whitespace', 'remove_trailing_lines'],
      \}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Keybindings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = '\'

" Clear all buffers and run Startify
map <leader>bd :bufdo %bd \| Startify<CR>

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
nnoremap <C-Tab> :tabnext<Bar>let &titlestring = ' ' . getcwd()<CR>
nnoremap <C-S-Tab> :tabprevious<Bar>let &titlestring = ' ' . getcwd()<CR>

" Terminal helper to open on the bottom
nnoremap <leader>c :bo term<CR><C-W>:res 10<CR>

" Find word under cursor in CWD recursively
nnoremap <C-S> :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Search tasks in current file
nnoremap <leader>t :silent Ggrep "TODO\\|FIXME"<CR>

" Remap wildmenu navigation
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" LSP support
nnoremap <leader>k :ALEHover<CR>
nnoremap <leader>d :ALEGoToDefinition<CR>
nnoremap <leader>r :ALERename<CR>

" Switch between completion methods
imap <c-j> <plug>(MUcompleteCycFwd)
imap <c-k> <plug>(MUcompleteCycBwd)

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
      \ escape(fnamemodify($HOME, ':p'), '\') .'.vim\\pack',
      \ escape(fnamemodify($HOME, ':p'), '\') .'.vimrc',
      \]

let g:startify_bookmarks = [
      \  {'c': '~/.vimrc'}, 
      \  {'w': '~/Google Drive/Praca/wiki/wiki.md'}, 
      \  {'n': '~/.vim/notes.md'}, 
      \  {'h': 'c:\Windows\System32\drivers\etc\hosts'}, 
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
" Buffer number in statusline
function! BufferNumberStatusLine()
  return len(filter(range(1,bufnr('$')), 'buflisted(v:val)'))
endf

" ALE status output in statusline
function! ALELinterStatusLine() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(
        \  '%dW %dE',
        \  all_non_errors,
        \  all_errors
        \)
endfunction

" Completeion method used in statusline
function! MUCompleteStatusLine()
  return get(g:mucomplete#msg#short_methods, get(g:, 'mucomplete_current_method', ''), '')
endf

set laststatus=2
set statusline=
set statusline+=%<[%{BufferNumberStatusLine()}]
set statusline+=\ [%{FugitiveHead(7)}]
set statusline+=\ %f
set statusline+=\ %y[%{&ff}]
set statusline+=[%{strlen(&fenc)?&fenc:&enc}a]
set statusline+=\ %h%m%r%w
set statusline+=\ [Syntax(%{ALELinterStatusLine()})]
set statusline+=%=
set statusline+=[MU\ %{MUCompleteStatusLine()}]
set statusline+=\ [GT\ %{gutentags#statusline()}]
set statusline+=\ %p%%
set statusline+=\ %l/%L:%c
