scriptencoding utf-8

" require 7.4.1154 for v:true, v:false, etc.
" require nocompatible, syntax, conceal, autocmd
if &compatible
      \ || v:version < 704
      \ || (v:version == 704 && !has('patch1154'))
      \ || !has('syntax')
      \ || !has('timers')
      \ || !has('autocmd')  " TODO: remove?
      \ || !has('conceal')
      \ || exists('g:loaded_visual_whitespace')
  finish
endif

let g:loaded_visual_whitespace = v:true

call timer_start(100, function('drawing#RedrawVisualWhitespace'), { 'repeat': -1 })

" if !exists('#VisualWhitespace')
"   augroup VisualWhitespace
"     autocmd!
"     autocmd CursorMoved * call drawing#RedrawVisualWhitespace()
"   augroup END
" endif
