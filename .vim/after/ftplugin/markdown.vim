if has('autocmd') && !exists('#SetSpellCheck')
  augroup SetSpellCheck
    autocmd!
    autocmd BufRead,BufNewFile,BufWinEnter,BufEnter *.{md,mdown,mkd,mkdn,markdown,mdwn}
          \ setlocal spell
    autocmd BufRead,BufNewFile,BufWinEnter,BufEnter *.{md,mdown,mkd,mkdn,markdown,mdwn}
          \ setlocal thesaurus+=~/.vim/thesaurus/mthesaur.txt
  augroup END
endif

" see https://github.com/plasticboy/vim-markdown/issues/232
if has('autocmd') && !exists('#AdjustListFormatting')
  augroup AdjustListFormatting
    autocmd FileType markdown
          \ set formatoptions-=q formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\[-*+]\\s\\+
  augroup END
endif
