"
" Sets test commands based on project type.
" Async tests with terminal location. Make sure that terminal window gets replaced not create new one.
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

function! ProjectDiscovery()
  let b:dispatch = v:false
  let b:dispatch_alt = v:false

  " Gradle support
  if filereadable('build.gradle') == 1
    let l:gradle = 'gradle'
    if filereadable('gradlew') == 1
      let l:gradle = './gradlew'
    endif

    let b:dispatch = l:gradle . ' clean build --info'
    let b:dispatch_alt = l:gradle . ' clean test --tests --info ' . substitute(expand('%:p:t'), '.groovy', '', 'g')

  " Maven Support
  elseif filereadable('pom.xml') == 1
    let b:dispatch = 'mvn clean install'

  " NodeJS/Angular support
  elseif filereadable('package.json') == 1
    let b:dispatch = 'yarn install & yarn build:prod'

  " Puppet support
  elseif filereadable('manifests/init.pp') == 1
    let b:dispatch = 'rake parallel_spec'
    let b:dispatch_alt = 'rake beaker'

  " Ansible support
  elseif filereadable('.ansible-lint') == 1
    let b:dispatch = 'ansible-lint ' . expand('%')

  " ICHA support
  elseif filereadable('Puppetfile') == 1
    let b:dispatch = 'ichatest.sh'
  endif
endfunction

" Per file type specific tests
augroup vimFilesTest
  " Set per project tests
  autocmd BufFilePre,BufRead,BufEnter,BufWinEnter * call ProjectDiscovery()

  " Reset tests for each file type
  autocmd FileType * let b:dispatch_file = v:false

  " File specific tests
  autocmd FileType ruby 
    \ if stridx(expand('%:t'), 'acceptance_spec.rb') > 0 |
    \   let b:dispatch_file = 'bash -c "BEAKER_destroy=no rspec ' . expand('%') . '"' |
    \ elseif stridx(expand('%:t'), '_spec.rb') > 0 |
    \   let b:dispatch_file = 'rspec --require ~/.vim/scripts/rspec_vim_formatter.rb' . ' --format VimFormatter ' . fnamemodify(expand('%'), ":~:.") |
    \ else |
    \   let b:dispatch_file = 'ruby %' |
    \ endif
  autocmd FileType groovy let b:dispatch_file = 'groovy ' . expand('%')
  autocmd FileType plantuml 
    \ let b:umltmpdir = $HOME . '/.vim/tmp' |
    \ let b:dispatch_file = 'plantuml -tsvg -o ' . b:umltmpdir . ' ' . expand('%')
    \   . g:netrw_browsex_viewer . ' ' . b:umltmpdir . '/%:t:gs?puml?svg?"'
  autocmd FileType python let b:dispatch_file = 'python ' . expand('%')
  autocmd FileType markdown let b:dispatch_file =  g:netrw_browsex_viewer . ' ' . expand('%:p')
  autocmd FileType puppet let b:dispatch_file = 'puppet apply --noop %'
  autocmd FileType sh let b:dispatch_file = 'bash ' . expand('%') 
  autocmd Filetype xml let b:dispatch_file = 'mvn clean install -f ' . expand('%')
augroup END

" Commands to use for tests
command RunProjectTest call RunTerminalCmd(b:dispatch)
command RunAlternativeTest call RunTerminalCmd(b:dispatch_alt)
command RunFile call RunTerminalCmd(b:dispatch_file)
command RunLastTest call RunTerminalCmd(g:last_terminal_test)
