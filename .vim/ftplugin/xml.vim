setlocal tabstop=4 shiftwidth=4

if match(expand('%:p:t'), 'pom.xml')
  let b:dispatch = 'cmd /c mvn clean install -f %'
endif
