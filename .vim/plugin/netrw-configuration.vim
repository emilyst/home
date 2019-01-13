let g:netrw_liststyle      = 1  " use long-style view by default ('i' cycles)
let g:netrw_preview        = 0  " open netrw preview in a horizontal split
let g:netrw_alto           = 0  " split to below
let g:netrw_altv           = 1  " split to the right
let g:netrw_winsize        = 30 " percent width of preview window
let g:netrw_browse_split   = 0  " browse by reusing same window
let g:netrw_keepdir        = 1  " never change directory
let g:netrw_mousemaps      = 0  " no mouse
let g:netrw_sort_by        = 'time'
let g:netrw_sort_direction = 'reverse'

if has('autocmd')
  augroup DeleteHiddenNetrwTreeViewBuffers
    autocmd!
    autocmd FileType netrw setlocal bufhidden=delete
  augroup END
endif
