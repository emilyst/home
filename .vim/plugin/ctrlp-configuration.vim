let g:ctrlp_extensions         = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript', 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
let g:ctrlp_cmd                = 'CtrlPMixed'
let g:ctrlp_match_window       = 'bottom,order:btt,min:1,max:10'
let g:ctrlp_mruf_relative      = 1

if filereadable(expand('~/.local/bin/ctags'))
  let g:ctrlp_buftag_ctags_bin = expand('~/.local/bin/ctags')
endif

let g:ctrlp_tjump_only_silent = 1
nnoremap <c-]> :CtrlPtjump<cr>
vnoremap <c-]> :CtrlPtjumpVisual<cr>

" match with vim-haystack
" function! CtrlPMatch(items, str, limit, mmode, ispath, crfile, regex) abort
"   let items = copy(a:items)
"   if a:ispath
"   call filter(items, 'v:val !=# a:crfile')
"   endif
"   return haystack#filter(items, a:str)
" endfunction
" let g:ctrlp_match_func = {'match': function('CtrlPMatch')}

if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command =
    \ 'ag %s -i --nocolor --nogroup --hidden
    \ --ignore .git
    \ --ignore target
    \ --ignore tags
    \ --ignore .tags
    \ --ignore .m2
    \ --ignore .svn
    \ --ignore .hg
    \ --ignore .DS_Store
    \ --ignore "**/*.pyc"
    \ -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  " let g:ctrlp_use_caching = 0
endif
