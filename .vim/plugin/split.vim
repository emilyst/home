function! s:SplitLine()
    let v = winsaveview()

    exe "keepjumps norm! i\<cr>\<esc>"
    exe "keepjumps norm! gk"

    let search = @/
    silent! s/\v +$//
    let @/ = search

    call winrestview(v)
endfunction
command! -nargs=0 SplitLine call s:SplitLine()
nnoremap S :SplitLine<cr>

