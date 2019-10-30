let g:grepper = {}
let g:grepper.highlight = 1
let g:grepper.prompt = 0
let g:grepper.dir = 'repo,cwd'
let g:grepper.tools = [
      \         'rg',
      \         'ag',
      \         'ack',
      \         'git',
      \         'grep',
      \         'findstr',
      \    ]
let g:grepper.rg = {
      \ 'grepprg': 'rg --vimgrep',
      \ 'escape':  '\^$.*+?()[]{}|'
      \ }

nmap <leader>*  <plug>(GrepperOperator)iw
xmap <leader>*  <plug>(GrepperOperator)

cnoreabbrev <expr> rg ((getcmdtype() is# ':' && getcmdline() is# 'rg')?('GrepperRg'):('GrepperRg'))
