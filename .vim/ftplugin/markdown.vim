setlocal spell tw=80
let b:dispatch = g:netrw_browsex_viewer . ' %'

" More flexible notes
if match(expand('%:p'), 'notes.md') > -1
  setlocal nospell tw=300
endif
