let g:grepper = {}
let g:grepper.highlight = 1
let g:grepper.prompt = 0
let g:grepper.dir = 'repo,cwd'
let g:grepper.tools = [
      \         'ag',
      \         'rg',
      \         'ack',
      \         'git',
      \         'grep',
      \         'findstr',
      \    ]
let g:grepper.rg = {
      \ 'grepprg': 'rg --vimgrep --smart-case --no-ignore',
      \ 'escape':  '\^$.*+?()[]{}|'
      \ }

nnoremap <leader>*  :Grepper -cword -noprompt<cr>
