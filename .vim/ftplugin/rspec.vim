setlocal re=1

let b:dispatch = "bash.exe -lc 'rspec --require /mnt/c/tools/rspec_vim_formatter.rb --format VimFormatter %:gs?\\\\?/?'"
