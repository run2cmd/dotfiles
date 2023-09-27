" Vim syntax file
" Language:     git - support for pretty git oneline
" Maintainer:   run2cmd

syn match GitShortCommit /^[a-z0-9]*/
syn match GitTagInfo /refs\/tags[^ ,)]*/
syn match GitTagTag 'tag:'
syn match GitHeadInfo /refs\/heads[^ ,)]*/
syn match GitHeadHead 'HEAD ->'
syn match GitRemotesInfo /refs\/remotes[^ ,)]*/

hi def GitShortCommit guifg=#ffcb6b
hi def GitTagInfo guifg=#FFCB6B gui=bold
hi def GitHeadHead guifg=#71c6e7
hi def GitHeadInfo guifg=#abcf76 gui=bold
hi def GitRemotesInfo guifg=#dc6068 gui=bold

hi link GitTagTag GitTagInfo
