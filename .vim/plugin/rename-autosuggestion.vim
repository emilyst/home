cnoreabbrev <expr> Rename <SID>FillInRenameFilename()

function! s:FillInRenameFilename() abort
  if getcmdtype() == ':' && getcmdline() =~ '^[rR]ename$'
    return 'Rename ' . expand('%:t')
  else
    return getcmdline()
  endif
endfunction
