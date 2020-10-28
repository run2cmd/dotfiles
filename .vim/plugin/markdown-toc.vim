function! s:FindHeaders()
  let l:winview = winsaveview()
  let l:flags = "Wc"
  let l:matches = []
  let l:searchRegex = "^[#]\\{2,}\\|.*\\n^[-]\\{2,}"
  normal! gg

  while search(l:searchRegex, l:flags) != 0
    let l:line = getline('.')
    let l:nextLine = getline(line('.') + 1)
    if(l:line[0] == "#")
      let l:matches += [l:line]
    else
      let l:matches += [l:nextLine . " " . l:line]
    endif
    let l:flags = "W"
  endwhile

  call winrestview(l:winview)

  return l:matches
endfunction

function! s:HeadingLevel(header)
  let l:delim = split(a:header, " ")[0] 
  if(l:delim[0] == "=")
    return 1
  elseif(l:delim[0] == "-")
    return 2
  else
    return len(l:delim)
  endif
endfunction

function! DeleteOldToc()
  normal! 3G
  if getline('.')[0] == '*'
    normal! V)d
  endif
endfunction

function! s:GenerateMarkdownTOC()
  call DeleteOldToc()
  normal! 2G

  let l:headerMatches = <SID>FindHeaders()

  let l:levelsStack = []
  let l:previousLevel = 0
  for header in l:headerMatches
    let l:headingLevel = <SID>HeadingLevel(header)
    let l:sectionName = join(split(header, " ")[1:-1], " ")
    let l:sectionId = substitute(substitute(tolower(sectionName), "[^a-z0-9_\\- ]", "", "g"), " ", "-", "g")

    if(l:headingLevel > l:previousLevel)
      call add(l:levelsStack, 1)
    elseif(l:headingLevel < l:previousLevel)
      call remove(l:levelsStack, -1)
    endif
    let l:previousLevel = l:headingLevel

    let l:formattedLine = repeat("  ", l:headingLevel - 2) . "* " . "[" . sectionName .  "](#" . sectionId  . ")"
    put =l:formattedLine
  endfor
  call append(line('.'), '')
endfunction

command! GenerateMarkdownTOC :call <SID>GenerateMarkdownTOC()
