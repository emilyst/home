" Split line at cursor, carefully avoiding moving the cursor or
" disturbing search, marks, jumps, etc.

function! s:SplitLine()
    " remember how we left things
    let view = winsaveview()
    let search = @/

    " input the linebreak itself
    exe "keepjumps norm! i\<cr>\<esc>"

    " hop back up a (visual) line and trim trailing whitespace
    exe "keepjumps norm! gk"
    silent! s/\v +$//

    " leave view and search how we found them
    call winrestview(view)
    let @/ = search
endfunction

command! -nargs=0 SplitLine call s:SplitLine()

nmap <LocalLeader><CR> :SplitLine<CR>
