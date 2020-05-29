setlocal re=1

function! PuppetManifestAlternateFile()
  let l:type = substitute(expand('%:p'), 'spec.*\(classes\|defines\)', 'manifests', 'g')
  let l:file = substitute(l:type, '_spec.rb$', '.pp', '')
  return AddToBufferIfExists(l:file)
endfunction

function! RubySourceAlternateFile()
  let l:file = substitute(expand('%:p'), 'spec', 'src', '')
  return AddToBufferIfExists(l:file)
endfunction

function! RubySpecAlternateFile()
  let l:file = substitute(expand('%:p'), 'src', 'spec', '')
  return AddToBufferIfExists(l:file)
endfunction

if match(expand('%:p'), 'classes') > -1 || match(expand('%:p'), 'defines') > -1
  let rubyAlterFile = PuppetManifestAlternateFile()
elseif match(expand('%:t'), '_spec.rb$') > -1
  let rubyAlterFile = RubySourceAlternateFile()
else
  let rubyAlterFile = RubySpecAlternateFile()
endif
 
if rubyAlterFile != '' && match(expand('%:p'), 'git') != -1
  let @# = rubyAlterFile
endif

if match(expand('%:t'), "_spec.rb$") > -1
  let b:dispatch = "bash.exe -lc 'rspec --format progress " . g:unix_path . "'"
else
  let b:dispatch = "ruby %"
endif

