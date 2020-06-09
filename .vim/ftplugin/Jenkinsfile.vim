setlocal tabstop=4 shiftwidth=4

if has('win32')
  let b:dispatch = $HOME . "\\scripts\\jlint.bat %"
endif
