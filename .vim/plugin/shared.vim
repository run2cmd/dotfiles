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

" Find file in current working directory and load result list to quickfix window
function! FindFileQuickfix(pattern) 
  if !exists('g:find_file_quickfix_command')
    if has('win32')
      let g:find_file_quickfix_command = 'dir /b/s'
    else
      let g:find_file_quickfix_command = 'find . -name'
    endif
  endif

  let l:output = system(g:find_file_quickfix_command . ' ' . a:pattern)
  let l:flist = split(l:output, '\n')
  let l:qlist = []

  for f in l:flist
    let l:dic = { 'filename': f, 'lnum': 1 }
    call add(l:qlist, l:dic)
  endfor

  if len(l:qlist) > 0
    call setqflist(l:qlist)
    cfirst
    copen
  else
    echo 'No matches found'
  endif
endf
