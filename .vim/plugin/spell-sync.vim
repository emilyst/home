function! s:RegenerateSpellfiles()
  for l:dir in split(globpath(&rtp, 'spell'), '\n')
    for l:wordlist in split(globpath(l:dir, '*.add'), '\n')
      if !filewritable(l:wordlist) | continue | endif

      let l:spellfile = l:wordlist . '.spl'

      if getftime(l:wordlist) > getftime(l:spellfile)
        silent execute 'mkspell! ' . fnameescape(l:wordlist)
      endif
    endfor
  endfor
endfunction

if has('autocmd') && !exists('#RegenerateSpellfiles')
  augroup RegenerateSpellfiles
    autocmd!
    autocmd VimEnter,VimLeave *  call <SID>RegenerateSpellfiles()
    autocmd FileWritePost,BufWritePost,FileAppendPost */.vim/spell/*.add call <SID>RegenerateSpellfiles()
  augroup END
endif
