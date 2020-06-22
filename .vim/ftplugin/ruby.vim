setlocal re=1

if match(expand('%:t'), "_spec.rb$") > -1
  let b:dispatch = "bash.exe -lc 'rspec --require /mnt/c/tools/rspec_vim_formatter.rb --format VimFormatter %:gs?\\\\?/?'"
else
  let b:dispatch = "ruby %"
endif
