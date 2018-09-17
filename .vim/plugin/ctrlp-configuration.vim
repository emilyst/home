let g:ctrlp_extensions          = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript', 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
let g:ctrlp_cmd                 = 'CtrlPMixed'
let g:ctrlp_match_window        = 'bottom,order:btt,min:1,max:10'
let g:ctrlp_mruf_relative       = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cache_dir           = expand('~/.vim/local/cache')

if filereadable(expand('~/.local/bin/ctags'))
  let g:ctrlp_buftag_ctags_bin = expand('~/.local/bin/ctags')
endif

let g:ctrlp_tjump_shortener = [ $HOME . '.*/gems/', '.../' ]
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

if executable('rg')
  " Use rg
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
endif

noremap <leader>o :CtrlPMixed<CR>
noremap <leader>p :CtrlP<CR>
noremap <leader>b :CtrlPBuffer<CR>
noremap <leader>u :CtrlPUndo<CR>
noremap <leader>T :CtrlPTag<CR>
noremap <leader>t :CtrlPBufTagAll<CR>
noremap <leader>m :CtrlPMRUFiles<CR>
