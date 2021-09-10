" Dummy function to use vim-rooter settings for tags generation
function! FindGutentagsRootDirectory(path)
  return FindRootDirectory()
endf

" COC Completion not activate on backspace
function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" COC support for native and hover documentation
function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
