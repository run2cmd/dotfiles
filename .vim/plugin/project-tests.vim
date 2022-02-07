"  Sets test commands based on project type.
function! ProjectDiscovery()
  let b:dispatch = v:false
  let b:dispatch_alt = v:false

  " Gradle support
  if filereadable('build.gradle') == 1
    let l:gradle = 'gradle'
    if filereadable('gradlew') == 1
      let l:gradle = './gradlew'
    endif

    let b:dispatch = 'bash -lc "' . l:gradle . ' clean build --info"'
    let b:dispatch_alt = 'bash -lc "' . l:gradle . ' clean test --info --tests ' . substitute(expand('%:p:t'), '.groovy', '', 'g') . '"'

  " Maven Support
  elseif filereadable('pom.xml') == 1
    let b:dispatch = 'bash -lc "mvn clean install -f %"'

  " NodeJS/Angular support
  elseif filereadable('package.json') == 1
    let b:dispatch = 'bash -lc "yarn install & yarn build:prod"'

  " Puppet support
  elseif filereadable('manifests/init.pp') == 1
    let b:dispatch = 'bash -lc "rake parallel_spec"'
    let b:dispatch_alt = 'bash -lc "rake beaker"'

  " Ansible support
  elseif filereadable('.ansible-lint') == 1
    let b:dispatch = 'bash -lc "ansible-lint ' . substitute(expand('%'), '\', '/', 'g') . '"'

  " ICHA support
  elseif filereadable('Puppetfile') == 1
    let b:dispatch = 'cmd /c ichatest.bat'
  endif
endfunction

" Per file type specific tests
augroup vimFilesTest
  " Set per project tests
  autocmd BufFilePre,BufRead,BufEnter,BufWinEnter * call ProjectDiscovery()

  " Reset tests for each file type
  autocmd FileType * let b:dispatch_file = v:false

  " File specific tests
  autocmd FileType ruby 
    \ if stridx(expand('%:t'), '_spec.rb') > 0 |
    \   let b:dispatch_file = 'bash -lc "'
    \     . 'rspec --require /mnt/c/Users/'
    \     . substitute($USERNAME, '.*', '\L&', 'g')
    \     . '/.vim/scripts/rspec_vim_formatter.rb'
    \     . ' --format VimFormatter '
    \     . substitute(fnamemodify(expand('%'), ":~:."), '\', '/', 'g')
    \     . '"' |
    \ else |
    \   let b:dispatch_file = 'bash -lc "ruby %"' |
    \ endif
  autocmd FileType groovy let b:dispatch_file = 'cmd /c groovy %'
  autocmd Filetype Jenkinsfile let b:dispatch_file = 'cmd /c jlint.bat %'
  autocmd FileType plantuml 
    \ let b:umltmpdir = $HOME . '/.vim/tmp' |
    \ let b:dispatch_file = 'cmd /c "plantuml -tsvg -o ' . b:umltmpdir . ' % && '
    \   . g:netrw_browsex_viewer . ' ' . b:umltmpdir . '/%:t:gs?puml?svg?"'
  autocmd FileType python let b:dispatch_file = 'bash -lc "python %"'
  autocmd FileType markdown let b:dispatch_file =  g:netrw_browsex_viewer . ' ' . expand('%:p')
  autocmd FileType puppet 
    \ let b:dispatch_file = 'bash -lc "puppet apply --noop %"' |
    \ let b:testfile = substitute(expand('%:t'), '\..*', '_spec.rb', 'g')
  autocmd FileType sh let b:dispatch_file = 'bash -lc "bash %"'
augroup END

" Commands to use for tests
command RunProjectTest call RunTerminalCmd(b:dispatch)
command RunAlternativeTest call RunTerminalCmd(b:dispatch_alt)
command RunFile call RunTerminalCmd(b:dispatch_file)
command RunLastTest call RunTerminalCmd(g:last_terminal_test)
