set shortmess+=c
set belloff+=ctrlg
set completeopt=menu,menuone,noinsert

set complete=.
set complete+=w
set complete+=b
set complete+=u
set complete+=U
set complete+=t

let g:mucomplete#chains = {}
let g:mucomplete#chains.default  = ['path', 'omni', 'c-p', 'dict', 'uspl']
let g:mucomplete#chains.markdown = ['path', 'keyn', 'keyp', 'dict', 'uspl', 'thes']

let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#buffer_relative_paths = 1  " paths are relative to buffer, not pwd
let g:mucomplete#completion_delay = 1

" check spelling when at least four letters are typed
let s:spl_cond = { t -> &l:spelllang == 'en' && t =~# '\a\{4}$' }

" check ruby completions after dot or double-colon
let s:ruby_cond = { t -> t =~# '\%(\.\|::\)$' }

let g:mucomplete#can_complete = {}

" enable manual spellchecking and synonym lookup with <tab> in all
" buffers
let g:mucomplete#can_complete.default = {
      \   'uspl': {
      \     t -> g:mucomplete_with_key && &l:spelllang == 'en_us' && t =~# '\a\{4}$'
      \   },
      \   'thes': {
      \     t -> g:mucomplete_with_key && strlen(&l:thesaurus) > 0
      \   }
      \ }

" check omnicompletion in ruby
let g:mucomplete#can_complete.ruby = { 'omni': { t -> t =~# '\%(\.\|::\)$' }}

inoremap <silent> <plug>(MUcompleteFwdKey) <right>
imap <right> <plug>(MUcompleteCycFwd)
inoremap <silent> <plug>(MUcompleteBwdKey) <left>
imap <left> <plug>(MUcompleteCycBwd)
