function! s:Pulse()
  execute 'syntax sync fromstart'
  execute 'redraw!'

  redir => old_hi
    silent execute 'hi CursorLine'
  redir END
  let old_hi = split(old_hi, '\n')[0]
  let old_hi = substitute(old_hi, 'xxx', '', '')

  let steps = 12
  let width = 1
  let start = width
  let end = steps * width
  let color = 233

  for i in range(start, end, width)
    execute "hi CursorLine ctermbg=" . (color + i)
    redraw
    sleep 5m
  endfor
  for i in range(end, start, -1 * width)
    execute "hi CursorLine ctermbg=" . (color + i)
    redraw
    sleep 5m
  endfor

  execute 'hi ' . old_hi
endfunction

command! -nargs=0 Pulse call s:Pulse()

nnoremap <c-c> :Pulse<cr>
