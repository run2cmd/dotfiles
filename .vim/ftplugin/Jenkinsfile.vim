setlocal tabstop=4 shiftwidth=4

if has('win32')
  let b:dispatch = 'cmd /c ' . $HOME . '/.vim/scripts/jlint.bat %'
endif
