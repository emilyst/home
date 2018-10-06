" disable lexima when a popup menu is visible; can only do this after
" setting the default rules first

let g:lexima_no_default_rules = 1
call lexima#set_default_rules()
inoremap <expr> <CR> pumvisible() ? '<CR>' : lexima#expand('<LT>CR>', 'i')
