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

" Default Highlighting
" Mostly for Ruby, Bash, Python
hi Normal ctermfg=250 ctermbg=235
hi Comment ctermfg=DarkGray cterm=italic
hi Constant ctermfg=101
hi String ctermfg=131
hi Delimiter ctermfg=250
hi Identifier ctermfg=063 cterm=none
hi Statement ctermfg=DarkYellow
hi PreProc ctermfg=LightBlue
hi Define ctermfg=Blue
hi Include ctermfg=Blue
hi Type ctermfg=DarkGreen
hi Function ctermfg=065
hi Operator ctermfg=DarkRed
hi Ignore ctermfg=DarkRed
hi Error ctermfg=White ctermbg=Red cterm=reverse
hi Todo ctermfg=Black ctermbg=Yellow
hi Visual ctermfg=238 ctermbg=250
hi Search ctermfg=Black ctermbg=Red
hi Linenr ctermfg=DarkGray
hi CursorLine cterm=none
hi Special ctermfg=096
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
hi link Repeat Statement

" Terminal
hi Terminal ctermfg=LightGray

" Vimdiff
hi DiffAdd ctermfg=Yellow ctermbg=DarkGray cterm=none
hi DiffDelete ctermfg=Yellow ctermbg=DarkGray cterm=none
hi DiffChange ctermfg=Yellow ctermbg=DarkGray cterm=none
hi DiffText ctermfg=Red ctermbg=LightYellow cterm=none

" Popup Menu
hi Pmenu ctermfg=250 ctermbg=240
hi PmenuSel cterm=reverse
hi NormalFloat ctermfg=250 ctermbg=238

" Puppet
hi puppetVariable ctermfg=NONE

" Tabs
hi TabLineFill ctermfg=DarkGray
hi TabLine ctermfg=DarkGreen ctermbg=DarkGray cterm=none
hi TabLineSel ctermfg=Black ctermbg=DarkCyan

" Statusline
hi StatusLine ctermfg=DarkGreen ctermbg=239 cterm=none
hi WarningMsg ctermfg=DarkRed

" Sign Column
highlight SignColumn ctermbg=NONE cterm=NONE

" Gitsigns
hi link GitSignsAdd Type
hi GitSignsChange ctermfg=DarkYellow
hi GitSignsDelete ctermfg=DarkRed

" Markdown(build-in)
hi link markdownCode String
hi link markdownCodeDelimiter String
hi link markdownH1 Include
hi link markdownH2 markdownH1
hi link markdownH3 markdownH1
hi link markdownH4 markdownH1
hi link markdownH5 markdownH1

" Spell
hi SpellBad ctermfg=DarkGray ctermbg=White cterm=reverse
hi link SpellCap SpellBad
hi link SpellRare SpellBad
hi link SpellLocal SpellBad

" Telescope
hi TelescopeMatching ctermfg=131
hi link TelescopeSelection Visual

" TODO:
"  Bugi theme support to lua with support:
"    * Treesitter
"    * Alpha
"    * LSP
"    * Telescope
"    * Puppet
"    * Jenkinsfile
"    * Vim Diff
"    * Fugitive/Neogit
