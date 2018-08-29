" vim will remember and reuse views per buffer automatically
" (see :help :mkview)

if has('autocmd')
  augroup RememberLastView
    autocmd!
    autocmd BufWinLeave * silent! mkview
    autocmd BufWinEnter * silent! loadview
  augroup END
endif
