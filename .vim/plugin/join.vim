" Join lines, carefully avoiding moving the cursor or disturbing marks,
" jumps, etc.

function! s:JoinLine()
    let v = winsaveview()
    keepjumps join
    call winrestview(v)
endfunction

command! -nargs=0 JoinLine call s:JoinLine()

nnoremap J :JoinLine<cr>
