setlocal tabstop=4 shiftwidth=4

if filereadable('gradlew')
  let b:gradle = 'gradlew'
else
  let b:gradle = 'gradle'
endif

if match(expand('%:p:t'), '.gradle') > -1
  let b:dispatch = 'cmd /c ' . b:gradle . ' clean build'
else
  let b:dispatch = 'cmd /c ' . b:gradle . ' clean build --info'
endif
