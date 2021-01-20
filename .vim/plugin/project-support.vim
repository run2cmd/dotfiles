" Determine project type
"
function! ProjectDiscovery()

  " Gradle support
  if filereadable('build.gradle') == 1
    if filereadable('gradlew') == 1
      let l:gradle = 'gradlew'
    else
      let l:gradle = 'gradle'
    endif

    if match(expand('%:p:t'), 'Test.groovy') > -1
      return 'cmd /c ' . l:gradle . ' clean test --info --tests ' . substitute(expand('%:p:t'), '.groovy', '', 'g')
    else
      return 'cmd /c ' . l:gradle . ' clean build --info'
    endif

  " Maven Support
  elseif filereadable('pom.xml') == 1
    return 'cmd /c mvn clean install -f %'

  " NodeJS/Angular support
  elseif filereadable('package.json')
    return 'cmd /c "yarn install & yarn build:prod"'
  endif

endfunction
