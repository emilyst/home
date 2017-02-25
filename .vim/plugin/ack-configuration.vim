if executable('rg')
  let g:ackprg = 'rg --smart-case --vimgrep'
elseif executable('ag')
  let g:ackprg = 'ag --smart-case --vimgrep'
endif

" easier to type 'Ack' without using shift
cnoreabbrev <expr> ack ((getcmdtype() is# ':' && getcmdline() is# 'ack')?('Ack'):('ack'))

nnoremap <leader>* :Ack! -i '\b<c-r><c-w>\b'<cr> " ack word under cursor
nnoremap <leader>8 :Ack! -i '\b<c-r><c-w>\b'<cr> " ack word under cursor
nnoremap <leader>g* :Ack! -i '<c-r><c-w>'<cr> " fuzzy ack word under cursor
nnoremap <leader>g8 :Ack! -i '<c-r><c-w>'<cr> " fuzzy ack word under cursor
