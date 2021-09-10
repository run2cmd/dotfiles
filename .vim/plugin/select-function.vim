" Select entire function or class
let s:block_types = ['ruby']
let s:brace_types = ['puppet', 'groovy']
let s:indent_types = ['yaml'] 
let s:lsp_support = ['python']

function! VisualSelectFunction()
  if index(s:brace_types, &filetype) >= 0
    let l:keyset = 'a{V'
  elseif index(s:block_types, &filetype) >= 0
    call searchpair('(\<do\>|\<if\>|\<unless\>|\<def\>|\<class\>)', '', '\<end\>', 'W')
    let l:keyset = '%V'
  elseif index(s:indent_types, &filetype) >= 0
    let l:keyset = 'ai'
  endif

  if index(s:lsp_support, &filetype) >= 0
    execute "call CocAction('selectSymbolRange', v:false, visualmode(), ['Method', 'Function'])"
  else
    execute 'normal v' . l:keyset
  endif
endfunction
