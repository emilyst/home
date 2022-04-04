let g:airline_theme                            = 'nord_minimal'
let g:airline_highlighting_cache               = 1
let g:airline_powerline_fonts                  = 1

if !exists('g:airline_symbols')
  let g:airline_symbols                        = {}
endif

let g:airline_left_sep                         = "╱"
" let g:airline_right_sep                      = "╱"
let g:airline_right_sep                        = ""
let g:airline_left_alt_sep                     = "╱"
let g:airline_right_alt_sep                    = "╱"

let g:airline_symbols.branch                   = ''
let g:airline_symbols.colnr                    = '✕'
let g:airline_symbols.dirty                    = '*'
let g:airline_symbols.linenr                   = ' ␤'
let g:airline_symbols.maxlinenr                = ''
let g:airline_symbols.whitespace               = '␣'

let g:airline#extensions#tabline#enabled       = 1
let g:airline#extensions#tabline#show_buffers  = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#close_symbol  = '×'
let g:airline#extensions#tabline#formatter     = 'unique_tail_improved'
let g:airline#extensions#tabline#tab_nr_type   = 1
