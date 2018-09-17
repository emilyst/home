if exists(":RainbowParentheses")
  RainbowParentheses
endif

" " wacky shit: read in tags from Ruby system and gems
" if executable('gem')
"       \ && exists('*pathogen#legacyjoin')
"       \ && exists('*pathogen#uniq')
"       \ && exists('*pathogen#split')
"   let gem_tags = trim(system('gem env home')) . '/**/tags'
"   let &l:tags = string(pathogen#legacyjoin(pathogen#uniq(pathogen#split(&tags) + [gem_tags])))
" endif
