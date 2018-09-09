" rhubarb#omnifunc doesn't work well with an autocomplete plugin, so I'm
" disabling it here

if has('autocmd')
  augroup rhubarb
    autocmd!
  augroup END

  " clearing the above augroup probably makes this redundant, but just
  " in case it's needed
  autocmd BufEnter *
        \ if expand('%:p') =~# '\.git[\/].*MSG$'
        \   && getbufvar('#', '&omnifunc') ==# 'rhubarb#omnifunc' |
        \   setlocal omnifunc=                                    |
        \ endif
endif
