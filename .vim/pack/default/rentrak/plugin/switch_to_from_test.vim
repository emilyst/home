function! s:SwitchToFromTest() " {{{
    let currentfilename   = expand("%:t")
    let pathtocurrentfile = expand("%:p:h")
    let endofpath         = fnamemodify(pathtocurrentfile, ":t")

    if endofpath == "TEST"
        let filename = fnamemodify(pathtocurrentfile, ":h") . "/" . currentfilename
    else
        let filename = pathtocurrentfile . "/TEST/" . currentfilename
    endif

    silent! execute "e " . filename
    " echo "Switched to " . filename
endfunction " }}}

command! SwitchToFromTest call s:SwitchToFromTest()
nnoremap <leader>gt :SwitchToFromTest<CR>
nnoremap <leader>gi :SwitchToFromTest<CR> " simulate old go-to-implementation
