if has('autocmd')
  augroup AsperitiesSpellFile
    autocmd!
    autocmd BufRead,BufNewFile,BufWinEnter,BufEnter
          \ ~/.local/writing/asperities/*.{md,mdown,mkd,mkdn,markdown,mdwn}*
          \ call s:AppendSpellfile(expand('~/.local/writing/asperities/glossary.utf-8.add'))
  augroup END
endif

function! s:AppendSpellfile(spellfile) abort
  if filereadable(a:spellfile)
    let &l:spellfile = join(uniq(split(&l:spellfile, ',') + [a:spellfile]), ',')
  else
    echohl ErrorMsg
    echom 'Could not open spellfile' a:spellfile
    echohl None
  endif
endfunction
