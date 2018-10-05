set shortmess+=c
set belloff+=ctrlg
set completeopt=menu,menuone,noinsert

let g:mucomplete#enable_auto_at_startup = 0
let g:mucomplete#buffer_relative_paths = 1  " ???

" check spelling when at least four letters are typed
let s:spl_cond = { t -> &l:spelllang == 'en' && t =~# '\a\{4}$' }

" check ruby completions after dot or double-colon
let s:ruby_cond = { t -> t =~# '\%(\.\|::\)$' }

let g:mucomplete#can_complete = {}

" check spelling in all buffers
" let g:mucomplete#can_complete.default = { 'uspl': { t -> &l:spelllang == 'en_us' && t =~# '\a\{4}$' }}

" check omnicompletion in ruby
let g:mucomplete#can_complete.ruby = { 'omni': { t -> t =~# '\%(\.\|::\)$' }}

let g:mucomplete#chains = {}
let g:mucomplete#chains.default  = ['omni', 'c-p']
let g:mucomplete#chains.markdown = ['keyn', 'dict', 'uspl']

inoremap <silent> <plug>(MUcompleteFwdKey) <right>
imap <right> <plug>(MUcompleteCycFwd)
inoremap <silent> <plug>(MUcompleteBwdKey) <left>
imap <left> <plug>(MUcompleteCycBwd)
