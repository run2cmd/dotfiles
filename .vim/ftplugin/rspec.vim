setlocal re=1

let bash_formatter_path = '/mnt/' . substitute(substitute(substitute($HOME . '\.vim\scripts\rspec_vim_formatter.rb', '\', '/', 'g'), ':', '', 'g'), '.*', '\L&', 'g')

if match(expand('%:p'), '_spec.rb') > -1
  let b:dispatch = 'bash.exe -lc "rspec --require ' . bash_formatter_path . ' --format VimFormatter %:gs?\?/?"'
else 
  let b:dispatch = "cmd /c ruby %"
endif
