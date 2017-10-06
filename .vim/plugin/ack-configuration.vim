if executable('rg')
  let g:ackprg = 'rg --smart-case --vimgrep'
elseif executable('ag')
  let g:ackprg = 'ag --smart-case --vimgrep'
endif

" easier to type 'Ack' without using shift
cnoreabbrev <expr> ack ((getcmdtype() is# ':' && getcmdline() is# 'ack')?('Ack'):('ack'))

" nnoremap <leader>* :Ack! -i '\b<c-r><c-w>\b'<cr> " ack word under cursor
" nnoremap <leader>8 :Ack! -i '\b<c-r><c-w>\b'<cr> " ack word under cursor
" nnoremap <leader>g* :Ack! -i '<c-r><c-w>'<cr> " fuzzy ack word under cursor
" nnoremap <leader>g8 :Ack! -i '<c-r><c-w>'<cr> " fuzzy ack word under cursor

" I'm grateful to Steve Losh for finding this awful bug, which I'm
" just copying and pasting below, with a slightly different mapping and
" adapted very slightly for `rg` compatibility
"
" With C-R C-W, according to the help: "With CTRL-W the part of the word
" that was already typed is not inserted again."  Because we're using \b
" to ack for word boundaries, the command string looks like `:Ack! '\b`
" at this point, and so if the word we're on happens to start with
" a lowercase b (e.g. "bonkers") it will be skipped, and we'll end up
" with `:Ack! '\bonkers` and find nothing.  It took me a good long time
" to notice this one.  Computers are total fucking garbage.
nnoremap <leader>* viw:<C-U>call <SID>AckMotion(visualmode())<CR>

function! s:CopyMotionForType(type)
  if a:type ==# 'v'
    silent execute "normal! `<" . a:type . "`>y"
  elseif a:type ==# 'char'
    silent execute "normal! `[v`]y"
  endif
endfunction

function! s:AckMotion(type) abort
  let reg_save = @@

  call s:CopyMotionForType(a:type)

  if executable('rg')
    execute "normal! :Ack! --fixed-strings " . shellescape(@@) . "\<cr>"
  elseif executable('ag')
    execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"
  endif

  let @@ = reg_save
endfunction
