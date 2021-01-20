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
" Section: Language, file encoding and format
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=en_US.UTF-8
let $LANG = 'en_US'
language en
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

" Disable mouse tooltips
set noballooneval

" Fix backspace
set backspace=indent,eol,start

" MuComplete AutoPairs integration
let g:AutoPairsMapSpace = 0
map <silent> <expr> <space> pumvisible()
   \ ? "<space>"
   \ : "<c-r>=AutoPairsSpace()<cr>"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Find and replace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch
set incsearch
set magic

" Include files in CWD
set path+=**

" Enable RipGrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-ignore\ -S
  let g:ctrlp_user_command='rg %s --files'
  let g:gutentags_file_list_command = 'rg --files . spec/fixtures/modules --no-messages' 
endif

let g:ctrlp_prompt_mappings = {
    \ 'PrtClearCache()':      ['<c-c>'],
    \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Secion: Diff mode
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

" Set default browser
if has('win32')
  let g:netrw_browsex_viewer = 'start qutebrowser'
else
  let g:netrw_browsex_viewer = 'xdg-open'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Autocompletion
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

" Enable ALE completion 
set omnifunc=ale#completion#OmniFunc

let g:gutentags_cache_dir = '~/.vim/tags'

" Dummy function to use vim-rooter settings for tags generation
function! FindGutentagsRootDirectory(path)
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
let g:rooter_patterns = ['!^fixtures', '.git', '.svn', '.rooter']
let g:rooter_change_directory_for_non_project_files = 'current'
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
  autocmd BufFilePre,BufEnter,BufWinEnter *,!qf let &titlestring = ' ' . getcwd()

  " Set cursor at last position when opening files
  autocmd BufReadPost * 
        \ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " Project support
  autocmd BufFilePre,BufEnter,BufWinEnter * let b:dispatch = ProjectDiscovery()

  " Filetype support
  autocmd FileType dosbatch,winbatch setlocal tabstop=4 shiftwidth=4
  autocmd BufNewFile,BufReadPost .vimlocal,.vimterm setlocal syntax=vim filetype=vim

  " Ansible support
  autocmd BufFilePre,BufEnter,BufWinEnter *.{yaml,yml}
        \ if match(expand('%:p'), 'fugitive') == -1 |
        \   for strMatch in ["- hosts:", "- name:", "- tasks"] |
        \     if match(readfile(expand('%:p')), strMatch) > -1 | 
        \       setlocal filetype=ansible syntax=yaml | 
        \       break |
        \     endif |
        \   endfor |
        \ endif

  " Quickfix window behavior
  autocmd QuickFixCmdPost [^l]* copen 10
  autocmd QuickFixCmdPost    l* lopen 10
  autocmd FileType qf wincmd J

  " Close hidden buffers for Netrw
  autocmd FileType netrw setlocal bufhidden=wipe

  " Autosave
  autocmd CursorHold * 
        \ if &modified != 0 && bufname('%') != "" && 
        \ index(["terminal", "nofile"], &buftype) < 0 &&
        \ index(["gitcommit", "startify"], &filetype) < 0 |
        \   write |
        \ endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Syntaxt, Lint, Tests
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP is slower then ctags with Puppet and Ruby. It can fail on Python too.
let g:ale_disable_lsp = 1
let g:ale_set_balloons = 0
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

" Disable markdonw autofold
let g:vim_markdown_folding_disabled=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Section: Keybindings and commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = ' '

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
nnoremap <leader>k :tabnext<Bar>let &titlestring = ' ' . getcwd()<CR>
nnoremap <leader>j :tabprevious<Bar>let &titlestring = ' ' . getcwd()<CR>

" Close quickfix
nnoremap <leader>gq :cclose<CR>

" Terminal helper to open on the bottom
nnoremap <leader>c :bo terminal<CR><C-W>:res 10<CR>

" Find word under cursor in CWD recursively
nnoremap <leader>s :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Remap wildmenu navigation
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" Switch between completion methods
imap <c-j> <plug>(MUcompleteCycFwd)
imap <c-k> <plug>(MUcompleteCycBwd)

" CtrlP
nnoremap <C-h> :CtrlPBuffer<CR>

" Jump to test file
nnoremap <leader>t :execute 'e ' findfile(b:testfile)<CR>

" Easy terminal jobs
command -nargs=* Cmd call RunTerminalTest('cmd /c <args>')
command -nargs=* Bash call RunTerminalTest('bash -lc "<args>"')
command RunTest call RunTerminalTest(b:dispatch)
nnoremap `<CR> :RunTest<CR>

" Todo list
abbreviate todo ~/.vim/notes.md

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

set cmdheight=1
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

" Source local changes. They are either OS or project specific and should not be in repository
source $HOME/.vimlocal
