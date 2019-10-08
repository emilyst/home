set shortmess+=c
set belloff+=ctrlg

set noshowfulltag

set complete=
set complete+=.
set complete+=w
set complete+=b
set complete+=u
set complete+=U
set complete+=t

set completeopt=
set completeopt+=menuone
set completeopt+=noinsert
set completeopt+=popup

let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#buffer_relative_paths = 1  " paths are relative to buffer, not pwd
let g:mucomplete#completion_delay = 3000
" let g:mucomplete#popup_direction =
"       \ {
"       \   'path': 1,
"       \   'omni': 1,
"       \   'c-p':  1,
"       \   'c-n':  1,
"       \   'keyp': 1,
"       \   'keyn': 1,
"       \   'tags': 1,
"       \   'dict': 1,
"       \   'uspl': 1,
"       \ }

let g:mucomplete#chains = {}
" let g:mucomplete#chains.default =
"       \ [
"       \   "path",
"       \   "omni",
"       \   "c-p",
"       \   "c-n",
"       \   "keyp",
"       \   "keyn",
"       \   "tags",
"       \   "dict",
"       \   "uspl",
"       \ ]

let g:mucomplete#chains.markdown =
      \ [
      \   "keyp",
      \   "keyn",
      \   "dict",
      \   "uspl",
      \ ]


" check ruby completions after dot or double-colon

let s:ruby_cond = { t -> t =~# '\%(\.\|::\)$' }
let s:spl_cond  = { t -> &l:spelllang == 'en' && t =~# '\a\{4}$' }
let s:cpp_cond  = { t -> t =~# '\%(->\|::\)$' }

let g:mucomplete#can_complete         = {}
let g:mucomplete#can_complete.default = { 'uspl': s:spl_cond }
let g:mucomplete#can_complete.cpp     = { 'omni': s:cpp_cond }
let g:mucomplete#can_complete.ruby    = { 'omni': s:ruby_cond, }



" check omnicompletion in ruby
let g:mucomplete#can_complete.ruby = { 'omni': { t -> t =~# '\%(\.\|::\)$' }}

inoremap <silent> <plug>(MUcompleteFwdKey) <right>
imap <right> <plug>(MUcompleteCycFwd)
inoremap <silent> <plug>(MUcompleteBwdKey) <left>
imap <left> <plug>(MUcompleteCycBwd)
