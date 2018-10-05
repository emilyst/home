function! s:HardRedraw()
  silent! execute 'redraw!'
  silent! execute 'redrawstatus!'
  silent! execute 'syntax sync minlines=100'
endfunction

command! -nargs=0 HardRedraw call s:HardRedraw()

nnoremap <c-c> :HardRedraw<cr>
