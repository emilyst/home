let g:neocomplete#enable_at_startup  = 1
let g:neocomplete#enable_auto_select = 1
let g:neocomplete#enable_refresh_always = 1
let g:neocomplete#enable_multibyte_completion = 1

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'

" let g:neocomplete#sources#omni#input_patterns.lisp = '\%(([^)]\+\)\|\*[[:alnum:]_-]\+'
" let g:neocomplete#sources#omni#input_patterns.lisp = '<\|\s[[:alnum:]-]*'


" if !exists('g:loaded_neocomplete')
"   finish
" endif

" inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"
