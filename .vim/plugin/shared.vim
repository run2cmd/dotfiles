" Add file to buffer if exists and return it's path
" Used for alternate files setup
function! AddToBufferIfExists(file)
  if filereadable(a:file)
    execute 'badd' a:file
    return a:file
  else
    return ''
  endif
endf
