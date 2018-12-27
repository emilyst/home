cnoreabbrev <expr> Rename <SID>FillInRenameFilename()
cnoreabbrev <expr> rename <SID>FillInRenameFilename()

function! s:FillInRenameFilename() abort
  let l:line = getcmdline()
  if getcmdtype() == ':' && l:line =~ '^[rR]ename$'
    return 'Rename ' . expand('%:t')
  else
    return l:line
  endif
endfunction
