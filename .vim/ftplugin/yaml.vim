setlocal syntax=yaml filetype=yaml
let b:dispatch = "bash.exe -lc 'ansible-lint " . g:unix_path . "'"