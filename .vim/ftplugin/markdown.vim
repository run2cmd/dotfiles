let b:htmlfile = $HOME . '/.vim/tmp/' . expand('%:h:t') . '-' . expand('%:t') . '.html'
let b:dispatch = 'cmd /c pandoc -s -t html5 ' . expand("%") . " -o " . b:htmlfile . " -c " . $HOME . '\.vim\scripts\github.css' . ' --metadata title=' . expand('%:t')
"let @+ = b:htmlfile

" More flexible notes
if match(expand('%:p'), 'notes.md') > -1
  setlocal nospell
endif
