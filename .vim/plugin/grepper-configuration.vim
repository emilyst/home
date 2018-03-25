let g:grepper = {}
let g:grepper.dir = 'cwd'
let g:grepper.tools = [
      \         'rg',
      \         'ag',
      \         'ack',
      \         'git',
      \         'grep',
      \         'findstr',
      \    ]

nnoremap <leader>*  :Grepper -cword -noprompt<cr>
