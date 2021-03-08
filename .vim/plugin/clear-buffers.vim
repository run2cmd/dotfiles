" 
" Clear buffers not in PWD
"
function! ClearBuffersNotInPWD()
  let l:abstract_buffers = range(1, bufnr('$')) 
  let l:buffers_list = filter(l:abstract_buffers, 'buflisted(v:val)')
  for realbuf in l:buffers_list
    if match(bufname(realbuf), "^\\") > -1
      execute 'bd ' . realbuf
    endif
  endfor
endfunction
