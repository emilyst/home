" does not work with termguicolors for some reason

function! s:Pulse(...)
  silent! execute 'syntax sync minlines=60'
  silent! execute 'redraw'

  redir => l:cursorline_highlight
  silent! execute 'highlight CursorLine'
  redir END

  let l:cursorline_highlight =
        \ substitute(split(l:cursorline_highlight, '\n')[0], 'xxx', '', '')

  let l:steps = 12
  let l:width = 1
  let l:start = width
  let l:end   = steps * width
  if a:0 == 0
    let l:color = 233
  else
    let l:color = a:1
  endif

  for i in range(l:start, l:end, l:width)
    execute "highlight CursorLine ctermbg=" . (l:color + i)
    redraw
    sleep 5m
  endfor

  for i in range(l:end, l:start, -1 * l:width)
    execute "highlight CursorLine ctermbg=" . (l:color + i)
    redraw
    sleep 5m
  endfor

  silent! execute 'highlight ' . l:cursorline_highlight
endfunction

command! -nargs=* Pulse call s:Pulse(<f-args>)

" nnoremap <c-c> :Pulse<cr>
