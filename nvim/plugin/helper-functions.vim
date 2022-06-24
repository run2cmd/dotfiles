" Dummy function to use vim-rooter settings for tags generation
function! FindGutentagsRootDirectory(path)
  return FindRootDirectory()
endf

" Get neat documentation in terminal window
function! CallChtsh(params)
  if exists('t:doc_window_buffer') && bufexists(t:doc_window_buffer)
    execute 'bd! ' . t:doc_window_buffer
  endif
  execute 'split term://chtsh.sh ' . a:params
  let t:doc_window_buffer = bufnr('%')
endfunction

" Neovim LSP-client statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif
  return ''
endfunction
