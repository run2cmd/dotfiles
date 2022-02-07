" ALE status output in statusline
function! ALELinterStatusLine() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(
        \  '%dW %dE',
        \  all_non_errors,
        \  all_errors
        \)
endfunction

" Completeion method used in statusline
function! MUCompleteStatusLine()
  return get(g:mucomplete#msg#short_methods, get(g:, 'mucomplete_current_method', ''), '')
endf

" Dummy function to use vim-rooter settings for tags generation
function! FindGutentagsRootDirectory(path)
  return FindRootDirectory()
endf

" Select entire function or class
function! VisualSelectFunction()
  let s:block_types = ['ruby']
  let s:brace_types = ['puppet', 'groovy', 'json']
  let s:indent_types = ['yaml', 'python'] 

  if index(s:brace_types, &filetype) >= 0
    let l:keyset = 'a{V'
  elseif index(s:block_types, &filetype) >= 0
    call searchpair('(\<do\>|\<if\>|\<unless\>|\<def\>|\<class\>)', '', '\<end\>', 'W')
    let l:keyset = '%V'
  elseif index(s:indent_types, &filetype) >= 0
    let l:keyset = 'ai'
  endif
  execute 'normal v' . l:keyset
endfunction

" Get neat documentation in terminal window
function! CallChtsh(params)
  execute "term ++shell chtsh.bat " . a:params
endfunction
endfunction
