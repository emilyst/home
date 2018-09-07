set shortmess+=c
set belloff+=ctrlg
set completeopt=menu,menuone,noinsert

let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#buffer_relative_paths = 1  " ???

inoremap <silent> <plug>(MUcompleteFwdKey) <right>
imap <right> <plug>(MUcompleteCycFwd)
inoremap <silent> <plug>(MUcompleteBwdKey) <left>
imap <left> <plug>(MUcompleteCycBwd)
