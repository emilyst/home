if has('autocmd') && !exists('#SpellCheck')
  augroup SpellCheck
    autocmd!
    autocmd BufRead,BufNewFile,BufWinEnter,BufEnter *.{md,mdown,mkd,mkdn,markdown,mdwn}*
          \ setlocal spell
    autocmd BufRead,BufNewFile,BufWinEnter,BufEnter *.{md,mdown,mkd,mkdn,markdown,mdwn}*
          \ setlocal thesaurus+=~/.vim/thesaurus/mthesaur.txt
  augroup END
endif

" see https://github.com/plasticboy/vim-markdown/issues/232
" and https://github.com/plasticboy/vim-markdown/issues/246
if has('autocmd') && !exists('#AdjustListFormattingContextually')
  augroup AdjustListFormattingContextually
    autocmd!
    autocmd CursorMovedI,CursorMoved *.{md,mdown,mkd,mkdn,markdown,mdwn}*
          \ call <SID>SetFormatOptionsContextually()
  augroup END
endif

" " Set up formatlistpat to handle various denotions of indention/hierarchy
" set formatlistpat=
" " Leading whitespace
" set formatlistpat+=^\\s*
" " Start class
" set formatlistpat+=[
" " Optionially match opening punctuation
" set formatlistpat+=\\[({]\\?
" " Start group
" set formatlistpat+=\\(
" " A number
" set formatlistpat+=[0-9]\\+
" " Roman numerals
" set formatlistpat+=\\\|[iIvVxXlLcCdDmM]\\+
" " A single letter
" set formatlistpat+=\\\|[a-zA-Z]
" " End group
" set formatlistpat+=\\)
" " Closing punctuation
" set formatlistpat+=[\\]:.)}
" " End class
" set formatlistpat+=]
" " One or more spaces
" set formatlistpat+=\\s\\+
" " Or ASCII style bullet points
" set formatlistpat+=\\\|^\\s*[-+o*]\\s\\+

" also format mkdListItem and mkdListItemLine

" see https://github.com/plasticboy/vim-markdown/issues/232
if has('autocmd') && !exists('#AdjustListPattern')
  augroup AdjustListPattern
    autocmd!
    autocmd FileType markdown
          \ setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*\[-*+]\\s\\+
  augroup END
endif

" TODO: consider disabling 'a' within the first word of a line, due to
" lists beginning with numbers or letters which cannot be readily
" identified as such until a few characters have been typed
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
