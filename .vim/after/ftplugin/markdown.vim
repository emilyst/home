if has('autocmd') && !exists('#SetSpellCheck')
  augroup SetSpellCheck
    autocmd!
    autocmd BufRead,BufNewFile,BufWinEnter,BufEnter *.{md,mdown,mkd,mkdn,markdown,mdwn} setlocal spell
  augroup END
endif
