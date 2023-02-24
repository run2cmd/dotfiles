" Vim syntax file
" Language:     note - like markdown
" Maintainer:   run2cmd

syn match noteH1 "^# .*"
syn match noteH2 "^## .*"
syn match noteFailCheck '\[x\]'
syn match noteSuccessCheck '\[v\]'
syn match noteWarningCheck '\[-\]'
syn region noteCode start="`" end="`" keepend
syn match noteListMarker "^[-]\S*"
syn match noteUrl "https\?://\S*"

hi def noteH1 guifg=white gui=bold
hi def noteH2 guifg=orange
hi def noteCode guifg=#e86671
hi def link noteCodeBlock noteCode
hi def noteListMarker guifg=cyan
hi def link noteUrl Underlined
hi def noteFailCheck guifg=red
hi def noteSuccessCheck guifg=green
hi def noteWarningCheck guifg=yellow
