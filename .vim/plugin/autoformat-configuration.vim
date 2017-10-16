noremap <leader>f :Autoformat<CR>
if executable('scalafmt')
  let g:formatters_scala = ['scalafmt']
  let g:formatdef_scalafmt = '"scalafmt --config .scalafmt.conf --stdin 2>/dev/null"'
endif
