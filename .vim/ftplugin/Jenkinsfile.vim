setlocal tabstop=4 shiftwidth=4

if has('win32')
  let b:dispatch = $HOME . "\\scripts\\jlint.bat % " . g:jenkins_user . " " . g:jenkins_node . " " . g:jenkins_port
else
  let b:dispatch = "ssh -o StrictHostKeyChecking=no -l " . g:jenkins_user . " " . g:jenkins_node . "-p " . g:jenkins_port . " declarative-linter < %"
endif
