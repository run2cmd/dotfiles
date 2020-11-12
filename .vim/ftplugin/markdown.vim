setlocal spell tabstop=2 shiftwidth=2
let b:dispatch = 'cmd /c ' . g:netrw_browsex_viewer . ' %'

" More flexible notes
if match(expand('%:p'), 'notes.md') > -1
  setlocal nospell
endif
