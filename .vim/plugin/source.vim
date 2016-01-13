" from http://stackoverflow.com/a/20265113

" This script provides :Source command, a drop-in replacement for
" built-in :source command, but this one also can take range and execute
" just a part of the buffer.

function! <SID>SourcePart(line1, line2)
   let tmp = @z
   silent exec a:line1.",".a:line2."yank z"
   let @z = substitute(@z, '\n\s*\\', '', 'g')
   @z
   let @z = tmp
endfunction

command! -nargs=? -bar -range Source if empty("<args>") | call <SID>SourcePart(<line1>, <line2>) | else | exec "so <args>" | endif

cnoreabbr so     Source
cnoreabbr sou    Source
cnoreabbr sour   Source
cnoreabbr sourc  Source
cnoreabbr source Source
