"  Sets test commands based on project type.

function! RvmBash(command)
  return 'bash -c ". ~/.bash_rvm; ' . a:command . '"'
endfunction

function! NvmBash(command)
  return 'bash -c ". ~/.bash_nvm; ' . a:command . '"'
endfunction

function! PyenvBash(command)
  return 'bash -c ". ~/.bash_pyenv; ' . a:command . '"'
endfunction

function! SdkBash(command)
  return 'bash -c ". ~/.bash_sdkman; ' . a:command . '"'
endfunction

function! ProjectDiscovery()
  let b:dispatch = v:false
  let b:dispatch_alt = v:false

  " Gradle support
  if filereadable('build.gradle') == 1
    let l:gradle = 'gradle'
    if filereadable('gradlew') == 1
      let l:gradle = './gradlew'
    endif

    let b:dispatch = SdkBash(l:gradle . ' clean build --info')
    let b:dispatch_alt = SdkBash(l:gradle . ' clean test --tests --info ' . substitute(expand('%:p:t'), '.groovy', '', 'g'))

  " Maven Support
  elseif filereadable('pom.xml') == 1
    let b:dispatch = SdkBash('mvn clean install')

  " NodeJS/Angular support
  elseif filereadable('package.json') == 1
    let b:dispatch = NvmBash('yarn install & yarn build:prod')

  " Puppet support
  elseif filereadable('manifests/init.pp') == 1
    let b:dispatch = RvmBash('rake parallel_spec')
    let b:dispatch_alt = RvmBash('rake beaker')

  " Ansible support
  elseif filereadable('.ansible-lint') == 1
    let b:dispatch = PyenvBash('ansible-lint ' . substitute(expand('%'), '\', '/', 'g'))

  " ICHA support
  elseif filereadable('Puppetfile') == 1
    let b:dispatch = NvmBash('/mnt/c/Users/' . substitute($USERNAME, '.*', '\L&', 'g') . '/bin/ichatest.sh')
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
    \ if stridx(expand('%:t'), 'acceptance_spec.rb') > 0 |
    \   let b:dispatch_file = RvmBash('BEAKER_destroy=no rspec ' . substitute(fnamemodify(expand('%'), ":~:."), '\', '/', 'g')) 
    \ elseif stridx(expand('%:t'), '_spec.rb') > 0 |
    \   let b:dispatch_file = RvmBash(
    \     . 'rspec --require /mnt/c/Users/'
    \     . substitute($USERNAME, '.*', '\L&', 'g')
    \     . '/.vim/scripts/rspec_vim_formatter.rb'
    \     . ' --format VimFormatter '
    \     . substitute(fnamemodify(expand('%'), ":~:."), '\', '/', 'g')
    \     . )
    \ else |
    \   let b:dispatch_file = RvmBash('ruby %') |
    \ endif
  autocmd FileType groovy let b:dispatch_file = SdkBash('groovy ' . substitute(expand('%'), '\', '/', 'g'))
  autocmd Filetype Jenkinsfile let b:dispatch_file = 'cmd /c jlint.bat %'
  autocmd FileType plantuml 
    \ let b:umltmpdir = $HOME . '/.vim/tmp' |
    \ let b:dispatch_file = 'cmd /c "plantuml -tsvg -o ' . b:umltmpdir . ' % && '
    \   . g:netrw_browsex_viewer . ' ' . b:umltmpdir . '/%:t:gs?puml?svg?"'
  autocmd FileType python let b:dispatch_file = PyenvBash('python ' . substitute(expand('%'), '\', '/', 'g'))
  autocmd FileType markdown let b:dispatch_file =  g:netrw_browsex_viewer . ' ' . expand('%:p')
  autocmd FileType puppet 
    \ let b:dispatch_file = 'bash -c "puppet apply --noop %"' |
    \ let b:testfile = substitute(expand('%:t'), '\..*', '_spec.rb', 'g')
  autocmd FileType sh let b:dispatch_file = 'bash -c "bash ' . substitute(expand('%'), '\', '/', 'g') .'"'
  autocmd Filetype xml let b:dispatch_file = SdkBash('mvn clean install -f ' . substitute(expand('%'), '\', '/', 'g'))
augroup END

" Commands to use for tests
command RunProjectTest call RunTerminalCmd(b:dispatch)
command RunAlternativeTest call RunTerminalCmd(b:dispatch_alt)
command RunFile call RunTerminalCmd(b:dispatch_file)
command RunLastTest call RunTerminalCmd(g:last_terminal_test)
