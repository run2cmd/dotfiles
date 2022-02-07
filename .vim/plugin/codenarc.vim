" Implement CodeNarc linting with ALE
"
" Example output line
" src/main/groovy/com/igt/groovy/dataCollector/interfaces/Icha.groovy:134:UnnecessaryGString The String 'conf/ansible.yaml' can be wrapped in single quotes instead of double quotes
"
function! Codenarc_callback(bufnr, lines) abort
  let lintMap = []
  let pattern = '\(.*\):\(\d\+\):\(.*\)$'
  for line in a:lines
    let matches = matchlist(line, pattern)
    if len(matches) >= 3
      let element = {
        \ 'text': matches[3],
        \ 'detail': matches[3],
        \ 'lnum': matches[2],
        \ 'filename': fnamemodify(matches[1], ':h'),
        \ 'type': 'W'
        \ }
      call add(lintMap, element)
    endif
  endfor
  return lintMap
endfunction
