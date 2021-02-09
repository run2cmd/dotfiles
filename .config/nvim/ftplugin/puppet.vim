let b:dispatch = 'cmd /c puppet apply --noop %'
let b:testfile = substitute(expand('%:t'), '\..*', '_spec.rb', 'g')
