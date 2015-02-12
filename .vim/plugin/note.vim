" Convenience function to start a new file in iCloud drive. The
" filename is a date and time, followed by an optional slug passed to
" the command.
"
function! s:Note(...)
    let l:slug = ''
    if a:0 > 0
        let l:slug = '-' . tolower(join(a:000, '-'))
    endif

    let l:basename  = strftime('%Y-%m-%d-%H%M%S') . l:slug
    let l:filename  = l:basename . '.mdown'
    let l:directory = expand('~/Library/Mobile\ Documents/com~apple~CloudDocs/Notes/')

    execute 'saveas ' l:directory . l:filename
endfunction
command! -nargs=* Note call s:Note(<f-args>)

