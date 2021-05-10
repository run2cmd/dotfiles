"
" Name: Bugi VIM colorscheme
" Scriptname: bugi.vim
" Original Author: Piotr Bugała <piotr.bugala@gmail.com> <https://github.com/run2cmd/bugi.vim.git>
" For GVim: Yes
" License: The Vim License (this command will show it: ':help copyright')
"
scriptencoding utf-8
hi clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'bugi'

" Set background
set background=dark

" Default Highliting
" Mostly for Ruby, Bash, Python
hi Normal ctermfg=LightGray guifg=Gray80 guibg=#383838
hi Comment ctermfg=DarkGray guifg=Gray40 term=italic gui=italic
hi Constant ctermfg=DarkYellow guifg=#d79921
hi String ctermfg=LightRed guifg=#fc7869
hi Delimiter ctermfg=LightGray guifg=Gray80
hi Identifier ctermfg=Cyan guifg=#66b5e5 gui=NONE
hi Statement ctermfg=Yellow guifg=#fabd2f
hi PreProc ctermfg=LightBlue guifg=#83a598
hi Define ctermfg=Blue cterm=bold guifg=#8a8ed0 gui=bold
hi Include ctermfg=Blue guifg=CornflowerBlue
hi Type ctermfg=DarkGreen guifg=#98971a
hi Function ctermfg=LightGreen guifg=#689d6a
hi Operator ctermfg=Red guifg=#cc241d
hi Ignore ctermfg=DarkRed guifg=#cc241d
hi Error ctermfg=White ctermbg=Red cterm=reverse guifg=#fbf1c7 guibg=#cc241d gui=reverse 
hi Todo ctermfg=Black ctermbg=Yellow guifg=#282828 guibg=#fabd2f
hi Visual ctermfg=Black ctermbg=LightGray guifg=#282828 guibg=LightGray
hi Search ctermfg=Black ctermbg=Red guifg=#282828 guibg=#cc241d
hi Linenr ctermfg=DarkGray guifg=Gray40 
hi CursorLine cterm=none gui=none guibg=NONE
hi link Character Constant
hi link Number Constant
hi link Boolean Constant
hi link Float Number
hi link Label Statement
hi link Exception Statement
hi link Macro PreProc
hi link PreCondit PreProc
hi link StorageClass Type
hi link Structure Type
hi link Typedef Type
hi link Tag Special
hi link SpecialChar Special
hi link SpecialComment Special
hi link Debug Special
hi link Keyword Statement
hi link Conditional Statement
hi link CursorLineNr Statement
hi link Special Constant
hi link Repeat Constant

" Vimdiff
hi DiffAdd ctermfg=LightGray ctermbg=Blue cterm=bold guifg=Gray80 guibg=#458588
hi DiffDelete ctermfg=DarkGray ctermbg=Blue cterm=bold guifg=Gray40 guibg=#458588
hi DiffChange ctermfg=LightGray ctermbg=DarkYellow cterm=bold guifg=Gray80 guibg=#b57614
hi DiffText ctermfg=Red ctermbg=Yellow cterm=bold guifg=#cc241d guibg=#fabd2f

" Popup Menu
hi Pmenu ctermfg=LightGray ctermbg=DarkGray guifg=Gray40 guibg=Gray80
hi PmenuSel ctermfg=DarkGray ctermbg=LightGray guifg=Gray80 guibg=Gray40

" Puppet
hi puppetVariable ctermfg=LightBlue guifg=#83a598

" Tabs
hi TabLineFill ctermfg=DarkGray guifg=Gray80
hi TabLine ctermfg=DarkGreen ctermbg=DarkGray cterm=bold guifg=#689d6a guibg=Gray40 gui=bold
hi TabLineSel ctermfg=Black ctermbg=DarkCyan guifg=#282828 guibg=DarkCyan

" Statusline
hi StatusLine ctermfg=DarkGreen ctermbg=DarkGray cterm=bold guifg=#b8bb26 guibg=Gray40 gui=bold
hi WarningMsg ctermfg=DarkRed guifg=#cc241d

" Sign Column
highlight SignColumn ctermbg=NONE cterm=NONE guibg=NONE gui=NONE

" Vim Signify
hi link SignifySignAdd Type
hi SignifySignChange ctermfg=DarkYellow guifg=#d79921
hi SignifySignDelete ctermfg=DarkRed guifg=#cc241d

" Ale Signs
hi ALEInfoSign ctermfg=DarkGreen guifg=#689d6a
hi ALEWarningSign ctermfg=DarkYellow ctermbg=DarkGray guifg=#d79921 guibg=Gray40
hi link ALEErrorSign Error

" Markdown(build-in)
hi link markdownCode String
hi link markdownCodeDelimiter String
