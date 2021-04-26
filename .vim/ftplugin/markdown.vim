let b:dispatch =  'vieb ' . expand('%:p')

" More flexible notes
if match(expand('%:p'), 'notes.md') > -1
  setlocal nospell
endif
