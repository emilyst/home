function! s:RegenerateSpellfiles() abort
  for l:dir in split(globpath(&rtp, 'spell'), '\n')
    for l:wordlist in split(globpath(l:dir, '*.add'), '\n')
      if !filewritable(l:wordlist) | continue | endif

      " sort the contents of the wordlist first
      call writefile(uniq(sort(readfile(l:wordlist))), l:wordlist)

      let l:spellfile = l:wordlist . '.spl'
      if !filewritable(l:spellfile) | continue | endif

      if getftime(l:wordlist) > getftime(l:spellfile)
        silent execute 'mkspell! ' . fnameescape(l:wordlist)
      endif
    endfor
  endfor
endfunction

" we can't autocmd on wordlist modifications or otherwise check for
" them, so we need to intercept the mappings which modify the wordlists
" directly
nnoremap zg
      \ zg<CR>
      \ :call <SID>RegenerateSpellfiles()<CR>
nnoremap zw
      \ zw<CR>
      \ :call <SID>RegenerateSpellfiles()<CR>
nnoremap zug
      \ zug<CR>
      \ :call <SID>RegenerateSpellfiles()<CR>
nnoremap zuw
      \ zuw<CR>
      \ :call <SID>RegenerateSpellfiles()<CR>

" define commands to replace the built-in ones, and try to override them
" with abbreviations (this inadvertently hides the versions ending in
" ! which operate on the internal wordlists, but I don't care)
function! s:Spellgood(count, word) abort
  if a:count
    execute a:count . 'spellgood ' . a:word
  else
    execute 'spellgood ' . a:word
  endif
  call s:RegenerateSpellfiles()
endfunction

function! s:Spellwrong(count, word) abort
  if a:count
    execute a:count . 'spellwrong ' . a:word
  else
    execute 'spellwrong ' . a:word
  endif
  call s:RegenerateSpellfiles()
endfunction

function! s:Spellundo(count, word) abort
  if a:count
    execute a:count . 'spellundo ' . a:word
  else
    execute 'spellundo ' . a:word
  endif
  call s:RegenerateSpellfiles()
endfunction

command! -nargs=1 -count Spellgood call s:Spellgood(<count>, <f-args>)
command! -nargs=1 -count Spellwrong call s:Spellwrong(<count>, <f-args>)
command! -nargs=1 -count Spellundo call s:Spellundo(<count>, <f-args>)

function! s:AbbreviateCommand(command, abbreviation) abort
  execute "cnoreabbrev <expr> " . a:abbreviation .
        \ " (getcmdtype() == ':' && getcmdline() =~ '^" . a:abbreviation . "$')"
        \ " ? '" . a:command . "' : '" . a:abbreviation . "'"
endfunction

call s:AbbreviateCommand('Spellgood',  'spellgood')
call s:AbbreviateCommand('Spellgood',  'spe')
call s:AbbreviateCommand('Spellwrong', 'spellwrong')
call s:AbbreviateCommand('Spellwrong', 'spellw')
call s:AbbreviateCommand('Spellundo',  'spellundo')
call s:AbbreviateCommand('Spellundo',  'spellu')

" for good measure, try to regenerate on vim startup and exit
if has('autocmd') && !exists('#RegenerateSpellfiles')
  augroup RegenerateSpellfiles
    autocmd!
    autocmd VimEnter,VimLeave * call <SID>RegenerateSpellfiles()
  augroup END
endif

