let g:ctrlp_extensions =
      \ [
      \   'tag',
      \   'buffertag',
      \   'quickfix',
      \   'dir',
      \   'rtscript',
      \   'undo',
      \   'line',
      \   'changes',
      \   'mixed',
      \   'bookmarkdir'
      \ ]
let g:ctrlp_cmd                 = 'CtrlPMixed'
let g:ctrlp_match_window        = 'bottom,order:btt,min:1,max:10'
let g:ctrlp_reuse_window        = 'netrw'
let g:ctrlp_mruf_relative       = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cache_dir           = expand('~/.vim/local/cache')

" I don't really use this, but just in case something is weird with the
" local system...
if filereadable(expand('~/.local/bin/ctags'))
  let g:ctrlp_buftag_ctags_bin = expand('~/.local/bin/ctags')
endif

" vim-ctrlp-tjump extension for jumping to ambiguous tags
let g:ctrlp_tjump_shortener =
      \ [
      \   $HOME . '.*/gems/',
      \   '.../'
      \ ]
let g:ctrlp_tjump_only_silent = 1
nnoremap <c-]> :CtrlPtjump<cr>
vnoremap <c-]> :CtrlPtjumpVisual<cr>

if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
endif

noremap <leader>T :CtrlPTag<CR>
noremap <leader>b :CtrlPBuffer<CR>
noremap <leader>m :CtrlPMRUFiles<CR>
noremap <leader>p :CtrlP<CR>
noremap <leader>t :CtrlPBufTagAll<CR>
noremap <leader>u :CtrlPUndo<CR>

" these are all defaults, listed here for reference
let g:ctrlp_prompt_mappings =
      \ {
      \   'PrtBS()':              ['<bs>', '<c-]>'],
      \   'PrtDelete()':          ['<del>'],
      \   'PrtDeleteWord()':      ['<c-w>'],
      \   'PrtClear()':           ['<c-u>'],
      \   'PrtSelectMove("j")':   ['<c-j>', '<down>'],
      \   'PrtSelectMove("k")':   ['<c-k>', '<up>'],
      \   'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
      \   'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
      \   'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
      \   'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
      \   'PrtHistory(-1)':       ['<c-n>'],
      \   'PrtHistory(1)':        ['<c-p>'],
      \   'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
      \   'AcceptSelection("h")': ['<c-x>', '<c-cr>', '<c-s>'],
      \   'AcceptSelection("t")': ['<c-t>'],
      \   'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
      \   'ToggleFocus()':        ['<s-tab>'],
      \   'ToggleRegex()':        ['<c-r>'],
      \   'ToggleByFname()':      ['<c-d>'],
      \   'ToggleType(1)':        ['<c-f>', '<c-up>'],
      \   'ToggleType(-1)':       ['<c-b>', '<c-down>'],
      \   'PrtExpandDir()':       ['<tab>'],
      \   'PrtInsert("c")':       ['<MiddleMouse>', '<insert>'],
      \   'PrtInsert()':          ['<c-\>'],
      \   'PrtCurStart()':        ['<c-a>'],
      \   'PrtCurEnd()':          ['<c-e>'],
      \   'PrtCurLeft()':         ['<c-h>', '<left>', '<c-^>'],
      \   'PrtCurRight()':        ['<c-l>', '<right>'],
      \   'PrtClearCache()':      ['<F5>'],
      \   'PrtDeleteEnt()':       ['<F7>'],
      \   'CreateNewFile()':      ['<c-y>'],
      \   'MarkToOpen()':         ['<c-z>'],
      \   'OpenMulti()':          ['<c-o>'],
      \   'PrtExit()':            ['<esc>', '<c-c>', '<c-g>'],
      \ }
