function! PuppetSpecAlternateFile()
  if match(readfile(expand('%:p')), "define") == -1
    let l:type = substitute(expand('%:p'), 'manifests', 'spec/classes', 'g')
  else
    let l:type = substitute(expand('%:p'), 'manifests', 'spec/defines', 'g')
  endif
  let l:file = substitute(l:type, '.pp$', '_spec.rb', 'g')
  return AddToBufferIfExists(l:file)
endfunction

let puppetAlterFile = PuppetSpecAlternateFile()
if puppetAlterFile != '' && match(expand('%:p'), 'git') != -1
  let @# = puppetAlterFile
endif

let b:dispatch = 'puppet apply --noop -t %'
