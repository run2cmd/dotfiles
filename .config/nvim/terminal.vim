" Vim like Terminal
set nocompatible

" Disable ~/.vim suport
set runtimepath=$VIMRUNTIME/vimfiles,$VIMRUNTIME

" Set proper enoding 
set langmenu=en_US.UTF-8
let $LANG = 'en_US'
language en
set spelllang=en_us

" Colors and fonts
"set guifont=Consolas:h11,Source_Code_Pro:h11,Hack:h11,Monospace:h11,Courier_New:h10
hi Normal ctermfg=LightGray guifg=Gray80 guibg=#383838

" Disable writing files
set undofile
set nobackup
set noswapfile

" Better search
set magic

" Show line numbers
set number
set relativenumber

autocmd! TermOpen * startinsert
autocmd! TabEnter * if line('.') == line('$') || line('.') < 55 | startinsert | endif

" Shortcuts
"let mapleader = ' '
tmap <C-W>n <C-\><C-N>
tmap <C-W>c <C-\><C-N>:tab new term://cmd /k clink inject<CR>
tmap <C-W>j <C-\><C-N>:tabnext<CR>
tmap <C-W>k <C-\><C-N>:tabprevious<CR>
imap <C-W>c <C-\><C-N>:tab new term://cmd /k clink inject<CR>
imap <C-W>j <C-\><C-N>:tabnext<CR>
imap <C-W>k <C-\><C-N>:tabprevious<CR>
nmap <C-W>c :tab new term://cmd /k clink inject<CR>
nmap <C-W>j :tabnext<CR>
nmap <C-W>k :tabprevious<CR>
tmap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

set laststatus=0

" Set pwd to homepath
execute "cd ~/"
