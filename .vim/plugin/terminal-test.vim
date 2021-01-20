" Run async tests
function! RunTerminalTest(params)
  if exists('t:test_window_buffer_number') && bufexists(t:test_window_buffer_number)
    execute 'bd ' . t:test_window_buffer_number
  endif
  execute 'bo' . ' terminal '. a:params 
  execute 'res 15'
  let t:terminal_window_buffer_number = bufnr('%')
  execute "normal! \<C-W>w"
  let t:test_window_buffer_number = t:terminal_window_buffer_number 
endfunction
