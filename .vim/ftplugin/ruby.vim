setlocal re=1

if match(expand('%:t'), "_spec.rb$") > -1
  let b:dispatch = "bash.exe -lc 'rspec --format progress %:gs?\\\\?/?'"
else
  let b:dispatch = "ruby %"
endif
