"
" Async tests with terminal location. Make sure that terminal window gets
" replaces not create new one.
"
function! RunTerminalTest(params)
  if exists('t:test_window_buffer_number') && bufexists(t:test_window_buffer_number)
    execute 'bd! ' . t:test_window_buffer_number
  endif
  execute 'bo terminal '. a:params 
  execute 'res 15'
  tnoremap <ESC> <C-w>N 
  let t:terminal_window_buffer_number = bufnr('%')
  let t:test_window_buffer_number = t:terminal_window_buffer_number 
endfunction
