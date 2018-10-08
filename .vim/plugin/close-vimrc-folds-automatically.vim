if has('autocmd') && !exists('#FoldVimrc')
  augroup FoldVimrc
    autocmd!
    autocmd BufEnter .vimrc normal! zM
  augroup END
endif
