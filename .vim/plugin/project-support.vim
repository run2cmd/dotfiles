" 
"  Sets test commands based on project type.
"
function! ProjectDiscovery()

  let bash_formatter_path = '/mnt/' . substitute(substitute(substitute($HOME . '\.vim\scripts\rspec_vim_formatter.rb', '\', '/', 'g'), ':', '', 'g'), '.*', '\L&', 'g')

  " Gradle support
  if filereadable('build.gradle') == 1
    if filereadable('gradlew') == 1
      let l:gradle = 'gradlew'
    else
      let l:gradle = 'gradle'
    endif

    if match(expand('%:p:t'), 'Test.groovy') > -1
      let b:dispatch = 'cmd /c ' . l:gradle . ' clean test --info --tests ' . substitute(expand('%:p:t'), '.groovy', '', 'g')
    else
      let b:dispatch = 'cmd /c ' . l:gradle . ' clean build --info'
    endif

  " Maven Support
  elseif filereadable('pom.xml') == 1
    let b:dispatch = 'cmd /c mvn clean install -f %'

  " NodeJS/Angular support
  elseif filereadable('package.json') == 1
    let b:dispatch = 'cmd /c "yarn install & yarn build:prod"'

  " Puppet support
  elseif filereadable('manifests/init.pp') == 1
    if match(expand('%:p:t'), 'acceptance_spec.rb') > -1
      let b:dispatch = 'bash -lc "rake beaker"'
    elseif match(expand('%:p:t'), '_spec.rb') > -1
      let b:dispatch = 'bash -lc "rspec --require ' . bash_formatter_path . ' --format VimFormatter ' . substitute(expand('%'), '\', '/', 'g') . '"'
    else 
      let b:dispatch = 'bash -lc "rake parallel_spec"'
    endif

  " Ansible support
  elseif filereadable('.ansible-lint')
    let b:dispatch = 'bash -lc \"ansible-lint ' . substitute(expand('%'), '\', '/', 'g') . '\"'
  endif

endfunction
