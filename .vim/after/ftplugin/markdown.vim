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

  if !exists('#FormatListPattern')
    augroup FormatListPattern
      autocmd!
      autocmd FileType markdown
            \ setlocal formatlistpat=
            \          formatlistpat+=^\\s*
            \          formatlistpat+=[
            \          formatlistpat+=\\[({]\\?
            \          formatlistpat+=\\(
            \          formatlistpat+=[0-9]\\+
            \          formatlistpat+=\\\|[iIvVxXlLcCdDmM]\\+
            \          formatlistpat+=\\\|[a-zA-Z]
            \          formatlistpat+=\\)
            \          formatlistpat+=[\\]:.)}
            \          formatlistpat+=]
            \          formatlistpat+=\\s\\+
            \          formatlistpat+=\\\|^\\s*[-+o*]\\s\\+
      autocmd FileType markdown setlocal formatoptions-=q
    augroup END
  endif

  if !exists('#FourSpaceIndent')
    augroup FourSpaceIndent
      autocmd!
      autocmd FileType markdown setlocal shiftwidth=4 tabstop=4 expandtab
    augroup END
  endif

  " if !exists('#FormatWithPandoc') && executable('pandoc')
  "   augroup FormatWithPandoc
  "     autocmd!
  "     autocmd FileType markdown
  "           \ setlocal equalprg=pandoc
  "           \          equalprg+=\ -f\ markdown+line_blocks+mmd_title_block+fancy_lists
  "           \          equalprg+=\ -t\ markdown+line_blocks+mmd_title_block+fancy_lists
  "           \          equalprg+=\ --columns\ 72
  "           \          equalprg+=\ --reference-links
  "           \          equalprg+=\ \|\ sed\ 's/\\(^\\s*\\)-\\(\\s\\s*\\)/\\1*\\2/g'
  "     autocmd FileType markdown let &l:formatprg=&l:equalprg
  "     " autocmd BufWritePre *.{md,mdown,mkd,mkdn,markdown,mdwn}*
  "     "       \ call s:FormatMarkdown()
  "   augroup END
  " endif
endif

function! s:FormatMarkdown() abort
  let l:view = winsaveview()
  keepjumps silent execute "normal! gggqG"
  silent redraw
  call winrestview(l:view)
endfunction

" set up command abbreviation, but only when the line is a command and
" not a search, and only when the abbreviation occurs at the beginning
" of the line
function! s:AbbreviateCommand(command, abbreviation) abort
  execute "cnoreabbrev <expr> " . a:abbreviation .
        \ " (getcmdtype() == ':' && getcmdline() =~ '^" . a:abbreviation . "$')"
        \ " ? '" . a:command . "' : '" . a:abbreviation . "'"
endfunction

command! FormatMarkdown call s:FormatMarkdown()
call s:AbbreviateCommand('FormatMarkdown',  'Format')
call s:AbbreviateCommand('FormatMarkdown',  'format')
