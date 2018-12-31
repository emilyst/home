if has('autocmd')
  augroup SpellFile
    autocmd!
    autocmd BufRead,BufNewFile,BufWinEnter,BufEnter
          \ ~/.local/writing/asperities/*.{md,mdown,mkd,mkdn,markdown,mdwn}*
          \ call s:AppendSpellfile('~/.local/writing/asperities/glossary.utf-8.add')
  augroup END
endif

function! s:AppendSpellfile(spellfile) abort
  let &l:spellfile = join(uniq(split(&l:spellfile, ',') + [a:spellfile]), ',')
endfunction
