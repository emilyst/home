" fix <CR> for neocomplete, which is only possible after lexima default
" rules are in place; the g:lexima_no_default_rules allows sourcing this
" file repeatedly
let g:lexima_no_default_rules = 1
call lexima#set_default_rules()
inoremap <expr> <CR> pumvisible() ? neocomplete#close_popup() : lexima#expand('<CR>', 'i')
