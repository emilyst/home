" base16-ocean has some poor contrast spell highlights, so force the
" background and foreground, and set underline
if has('termguicolors') && &termguicolors && exists('g:colors_name') && g:colors_name ==? 'base16-ocean'
  highlight SpellBad   guibg=#bf616a guifg=bg cterm=underline
  highlight SpellCap   guibg=#8fa1b3 guifg=bg cterm=underline
  highlight SpellLocal guibg=#96b5b4 guifg=bg cterm=underline
  highlight SpellRare  guibg=#b48ead guifg=bg cterm=underline
endif
