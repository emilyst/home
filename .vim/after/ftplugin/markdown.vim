if has('autocmd')
  if !exists('#SpellCheck')
    augroup SpellCheck
      autocmd!
      autocmd BufRead,BufNewFile,BufWinEnter,BufEnter *.{md,mdown,mkd,mkdn,markdown,mdwn}*
            \ setlocal spell
      autocmd BufRead,BufNewFile,BufWinEnter,BufEnter *.{md,mdown,mkd,mkdn,markdown,mdwn}*
            \ setlocal thesaurus+=~/.vim/thesaurus/mthesaur.txt
    augroup END
  endif

  if !exists('#CommentString')
    augroup CommentString
      autocmd!
      autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
      autocmd FileType markdown
            \ setlocal comments=b:>,b:*,b:+,b:-,s:<!--,m:\ \ \ \ ,e:-->
    augroup END
  endif

  if !exists('#FormatProg') && executable('pandoc')
    augroup FormatProg
      autocmd!
      autocmd FileType markdown
            \ setlocal equalprg=pandoc
            \          equalprg+=\ -f\ markdown+line_blocks+mmd_title_block+fancy_lists
            \          equalprg+=\ -t\ markdown+line_blocks+mmd_title_block+fancy_lists
            \          equalprg+=\ --columns\ 72
            \          equalprg+=\ --reference-links
            \          equalprg+=\ \|\ sed\ 's/\\(^\\s*\\)-\\(\\s\\s*\\)/\\1*\\2/g'
      autocmd FileType markdown let &l:formatprg=&l:equalprg
      autocmd FileType markdown setlocal shiftwidth=4 tabstop=4 expandtab
      autocmd BufWritePre *.{md,mdown,mkd,mkdn,markdown,mdwn}*
            \ silent execute "normal! m`gggqG``" | silent redraw
    augroup END
  endif
endif
