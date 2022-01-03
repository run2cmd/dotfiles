"
" Async tests with terminal location. Make sure that terminal window gets
" replaced not create new one.
"
function! RunTerminalCmd(params)
  let g:last_terminal_test = a:params
  if a:params == v:false
    echo "Missing terminal command to run"
    return
  endif

  if exists('t:terminal_window_buffer_number') && bufexists(t:terminal_window_buffer_number)
    execute 'bd! ' . t:terminal_window_buffer_number
  endif

  execute 'bo terminal '. a:params 
  execute 'res 15'
  tnoremap <ESC> <C-w>N 
  let t:terminal_window_buffer_number = bufnr('%')
endfunction
