" 
"  Sets test commands based on project type.
"
function! ProjectDiscovery()

  let b:dispatch = v:false
  let b:dispatch_file = v:false
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
