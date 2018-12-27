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
      autocmd FileType markdown
            \ setlocal commentstring=<!--\ %s\ -->
      autocmd FileType markdown
            \ setlocal comments=b:>,b:*,b:+,b:-,s:<!--,m:\ \ \ \ ,e:-->
    augroup END
  endif

  if !exists('#FormatProg')
    augroup FormatProg
      autocmd!
      autocmd FileType markdown
            \ setlocal equalprg=pandoc
            \          equalprg+=\ -f\ markdown+autolink_bare_uris
            \          equalprg+=\ -t\ markdown+autolink_bare_uris
            \          equalprg+=\ --atx-headers
            \          equalprg+=\ --columns\ 72
            \          equalprg+=\ --reference-links
      autocmd FileType markdown let &l:formatprg=&l:equalprg
    augroup END
  endif
endif

" TODO: consider disabling 'a' within the first word of a line, due to
" lists beginning with numbers or letters which cannot be readily
" identified as such until a few characters have been typed
"
" TODO: enable this again?
function! s:SetFormatOptionsContextually() abort
  let l:line = getline(line('.'))

  " Disable some automatic formatting if we're in a list or if the line
  " begins with some whitespace.
  if l:line =~? &l:formatlistpat || l:line =~? '^\\s+'
    setlocal formatoptions-=a  " Do not automatically format paragraphs as I type)
    setlocal formatoptions-=c  " Do not automatically wrap comments
    setlocal formatoptions-=o  " Do not automatically insert comment leader after hitting 'o'
    setlocal formatoptions-=q  " Do not automatically format comments with 'gq' or 'gw'
  else
    setlocal formatoptions+=a  " Automatically format paragraphs as I type)
    setlocal formatoptions+=c  " Automatically wrap comments (blockquotes)
    setlocal formatoptions+=o  " Automatically insert comment leader after hitting 'o' (blockquotes)
    setlocal formatoptions+=q  " Automatically format comments (blockquotes) with 'gq' or 'gw'
  endif
endfunction
