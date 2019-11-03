function! s:HardRedraw()
  silent! execute 'redraw!'
  silent! execute 'redrawstatus!'
  silent! execute 'syntax sync fromstart'
endfunction

command! -nargs=0 HardRedraw call s:HardRedraw()

nnoremap <c-c> :HardRedraw<cr>
