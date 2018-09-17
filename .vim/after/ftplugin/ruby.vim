if exists(":RainbowParentheses")
  RainbowParentheses
endif

" wacky shit: read in tags from Ruby system and gems
if executable('rbenv')
      \ && exists('*pathogen#legacyjoin')
      \ && exists('*pathogen#uniq')
      \ && exists('*pathogen#split')
  let &l:tags = pathogen#legacyjoin(
        \   pathogen#uniq(
        \     pathogen#split(&tags) + [system('rbenv prefix') . '/**/tags']
        \   )
        \)
endif
