"  Sets test commands based on project type.
function! ProjectDiscovery()
  let b:dispatch = v:false
  let b:dispatch_alt = v:false

  " Gradle support
  if filereadable('build.gradle') == 1
    let l:gradle = 'gradle'
    if filereadable('gradlew') == 1
      let l:gradle = 'gradlew'
    endif

    let b:dispatch = 'cmd /c ' . l:gradle . ' clean build --info'
    let b:dispatch_alt = 'cmd /c ' . l:gradle . ' clean test --info --tests ' . substitute(expand('%:p:t'), '.groovy', '', 'g')

  " Maven Support
  elseif filereadable('pom.xml') == 1
    let b:dispatch = 'cmd /c mvn clean install -f %'

  " NodeJS/Angular support
  elseif filereadable('package.json') == 1
    let b:dispatch = 'cmd /c "yarn install & yarn build:prod"'

  " Puppet support
  elseif filereadable('manifests/init.pp') == 1
    let b:dispatch = 'bash -lc "rake parallel_spec"'
    let b:dispatch_alt = 'bash -lc "rake beaker"'

  " Ansible support
  elseif filereadable('.ansible-lint')
    let b:dispatch = 'bash -lc \"ansible-lint ' . substitute(expand('%'), '\', '/', 'g') . '\"'
  endif
endfunction

" Per file type specific tests
augroup vimFilesTest
  " Set per project tests
  autocmd BufFilePre,BufEnter,BufWinEnter * call ProjectDiscovery()

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
        \     . substitute(expand('%'), '\', '/', 'g')
        \     . '"' |
        \ else |
        \   let b:dispatch_file = 'cmd /c ruby %' |
        \ endif
  autocmd FileType groovy let b:dispatch_file = 'cmd /c groovy %'
  autocmd Filetype Jenkinsfile let b:dispatch_file = 'cmd /c ' . $HOME . '/.vim/scripts/jlint.bat %'
  autocmd FileType plantuml 
        \ let b:dispatch_file = 'cmd /c "plantuml % && '. g:netrw_browsex_viewer .' %:p:gs?puml?png?"'
  autocmd FileType python let b:dispatch_file = 'cmd /c python %'
  autocmd FileType markdown let b:dispatch_file =  g:netrw_browsex_viewer . ' ' . expand('%:p')
  autocmd FileType puppet 
        \ let b:dispatch_file = 'cmd /c puppet apply --noop %' |
        \ let b:testfile = substitute(expand('%:t'), '\..*', '_spec.rb', 'g')
  autocmd FileType yaml
        \ let b:schemafile = 'schemas\' . substitute(expand('%'), 'yaml', 'json', 'g') |
        \ if filereadable(b:schemafile) == 1 |
        \   let b:testfile = substitute(expand('%:t'), '\..*', '.json', 'g') |
        \   let b:dispatch_file = 'cmd /c ' . $HOME . '/.vim/scripts/ajvlint.bat % ' . b:schemafile |
        \ endif 
augroup END

" Commands to use for tests
command RunProjectTest call RunTerminalCmd(b:dispatch)
command RunAlternativeTest call RunTerminalCmd(b:dispatch_alt)
command RunFile call RunTerminalCmd(b:dispatch_file)
