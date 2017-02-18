inoremap <expr> <CR> pumvisible() ? neocomplete#close_popup() : lexima#expand('<LT>CR>', 'i')
" call lexima#insmode#map_hook('before', '<cr>', "\<C-r>=neocomplete#close_popup()\<cr>")
