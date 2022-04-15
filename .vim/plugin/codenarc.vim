" Implement CodeNarc linting with ALE
"
" Example output line
" src/main/groovy/com/igt/groovy/dataCollector/interfaces/Icha.groovy:134:UnnecessaryGString The String 'conf/ansible.yaml' can be wrapped in single quotes instead of double quotes
"
function! Codenarc_callback(bufnr, lines) abort
  let lintMap = []
  let warn_pattern = '\(.*\):\(\d\+\):\(.*\)$'
  let err_pattern = '\(.*\): \(\d\+\): \(.*\)$'
  for line in a:lines
    let warn_matches = matchlist(line, warn_pattern)
    let err_matches = matchlist(line, err_pattern)
    if len(warn_matches) >= 3
      let element = {
        \ 'text': warn_matches[3],
        \ 'detail': warn_matches[3],
        \ 'lnum': warn_matches[2],
        \ 'filename': fnamemodify(warn_matches[1], ':h'),
        \ 'type': 'W'
        \ }
      call add(lintMap, element)
    elseif len(err_matches) >= 3
      let element = {
        \ 'text': err_matches[3],
        \ 'detail': err_matches[3],
        \ 'lnum': err_matches[2],
        \ 'filename': expand('%:h'),
        \ 'type': 'E'
        \ }
      call add(lintMap, element)
    endif
  endfor
  return lintMap
endfunction
