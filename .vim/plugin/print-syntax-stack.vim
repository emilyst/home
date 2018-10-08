function! s:PrintSyntaxStack()
  let l:names = map(synstack(line('.'), col('.')), { key, val -> synIDattr(val, 'name') })
  echom join(l:names, ' => ')
endfunction

map <F8> :call <SID>PrintSyntaxStack()<CR>
