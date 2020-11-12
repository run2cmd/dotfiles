" Run async tests
function! RunTerminalTest(params)
  if exists('b:test_window_buffer_number') && bufexists(b:test_window_buffer_number)
    execute 'bd ' . b:test_window_buffer_number
  endif
  execute 'bo' . ' terminal '. a:params 
  execute 'res 10'
  let g:terminal_window_buffer_number = bufnr('%')
  execute "normal! \<C-W>w"
  let b:test_window_buffer_number = g:terminal_window_buffer_number 
endfunction
