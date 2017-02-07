" 0 preamble ============================================================== {{{
"
" There is a great organization scheme in place here. If you run the
" :options command in Vim, you see a list of all the options that you
" can set, along with their current settings and a brief description of
" them. The great thing about this scheme is that--for better or
" worse--it sets up a system which can organize all my settings. I've
" decided to organize everything below thus, throwing ancillary things
" (my own mappings, plugin settings, and so on) where it makes sense.
"
" A lot of plugin settings end up going into the various section, and
" that seems fine. I'll probably collect lots of utility functions there
" as well as I go along.
"
" The great part about all this is that I have a sensible way now to
" extend this giant settings file so that I don't get so anxious about
" it.
"
" ========================================================================= }}}
" 1 important ============================================================= {{{

set all&
set nocompatible
if has('autocmd')
  au! BufEnter *
endif

runtime bundle/pathogen/autoload/pathogen.vim
if exists("g:loaded_pathogen")
  execute pathogen#infect()
  execute pathogen#helptags()
endif

" fix up rtp a bit to exclude rusty old default scripts if they exist
if exists("g:loaded_pathogen")
  let list = []
  for dir in pathogen#split(&rtp)
  if dir !~# '/usr/share/vim/vimfiles'
    call add(list, dir)
  endif
  endfor
  let &rtp = pathogen#join(list)
endif

" ========================================================================= }}}
" 2 moving around, searching and patterns ================================= {{{

set nostartofline

set magic
set ignorecase
set smartcase
set gdefault
set incsearch
" set showmatch
set hlsearch

" ========================================================================= }}}
" 3 tags ================================================================== {{{

set showfulltag
set tags+=./tags,./.tags,tags,.tags
set tagbsearch

" ========================================================================= }}}
" 4 displaying text ======================================================= {{{

set scroll=7
set scrolloff=10
set nowrap
set fillchars+=stl:\ 
set fillchars+=stlnc:\ 
set fillchars+=fold:\ 
set fillchars+=diff:\ 
set fillchars+=vert:\ 
set linebreak
set lazyredraw

set list
set listchars+=tab:›\ "
set listchars+=trail:·
set listchars+=nbsp:␣
set listchars+=extends:›
set listchars+=precedes:‹
set listchars+=eol:\ "
"set showbreak=→
" if exists('&relativenumber')
"   set relativenumber
" endif
set number
set numberwidth=5

" if has('autocmd')
"   augroup AlwaysRelative
"   au!
"   au BufReadPost *
"     \ if &number && exists('&relativenumber') |
"     \   silent! setl relativenumber           |
"     \   silent! setl number                   |
"     \ endif
"   augroup END
" endif

" ========================================================================= }}}
" 5 syntax, highlighting and spelling ===================================== {{{

syntax enable

if has('guicolors')
  set guicolors
endif

if has('termguicolors')
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set background=dark
colorscheme base16-ocean

"set cursorcolumn
" if exists('+colorcolumn') | set colorcolumn+=73,81 | endif
if exists('&colorcolumn') | let &colorcolumn=join([73,81] + range(101,9999), ',') | endif
set cursorline

set spelllang=en_us

" custom highlights

" hi LineNr       cterm=bold gui=bold " ctermbg=234 guibg=#222222
" hi SignColumn   cterm=bold gui=bold " ctermbg=234 guibg=#222222
" hi CursorLineNr cterm=bold gui=bold " ctermbg=234 guibg=#222222
" hi CursorLine   ctermbg=234 guibg=#222222
" hi ColorColumn  ctermbg=234 guibg=#222222
hi Comment term=italic cterm=italic gui=italic

hi SyntasticErrorSign   term=standout ctermfg=1 ctermbg=10 guifg=#bf616a guibg=#343d46
hi SyntasticWarningSign term=standout ctermfg=3 ctermbg=10 guifg=#ebcb8b guibg=#343d46
" hi SyntasticErrorLine   term=standout ctermfg=1 ctermbg=10 guifg=#bf616a guibg=#343d46
" hi SyntasticWarningLine term=standout ctermfg=3 ctermbg=10 guifg=#ebcb8b guibg=#343d46

hi Keyword term=bold cterm=bold gui=bold
hi Conditional term=bold cterm=bold gui=bold
hi Define term=bold cterm=bold gui=bold

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
match ErrorMsg 'd41d8cd9-8f00-3204-a980-0998ecf8427e'

" ========================================================================= }}}
" 6 multiple windows ====================================================== {{{

set winminheight=0
set winminwidth=0
set hidden
set switchbuf=useopen,usetab
set splitbelow
set splitright
set scrollopt=ver,hor,jump

" ========================================================================= }}}
" 7 multiple tab pages ==================================================== {{{

set showtabline=2

" ========================================================================= }}}
" 8 terminal ============================================================== {{{

"set ttyscroll=0
if exists('&ttyfast') | set ttyfast | endif
set title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
set titlelen=85

" " bar cursor in insert mode
" if exists('$TMUX')
"   let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"   let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
" else
"   let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"   let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" endif

" ========================================================================= }}}
" 9 using the mouse ======================================================= {{{

" if has('mouse')
"   set mouse+=a
"   set mousemodel=popup_setpos
"   if has('mouse_xterm') | set ttymouse=xterm2 | endif
"   if has('mouse_sgr') | set ttymouse=sgr | endif
" endif

" block select with control-click-and-drag
noremap <C-LeftMouse> <LeftMouse><Esc><C-V>
noremap <C-LeftDrag>  <LeftDrag>

" ========================================================================= }}}
" 10 GUI ================================================================== {{{

if has('gui_running')
  set linespace=0
  set guifont=SF\ Mono\ Light:h11
  if has('transparency')
    set transparency=0
  endif
endif

" ========================================================================= }}}
" 11 printing ============================================================= {{{



" ========================================================================= }}}
" 12 messages and info ==================================================== {{{

set noshowmode
set showcmd
set shortmess+=I

" ========================================================================= }}}
" 13 selecting text ======================================================= {{{

if has('clipboard')
  set clipboard=unnamed
  if has('xterm_clipboard')
    set clipboard+=unnamedplus
  endif
endif

"set selectmode+=mouse,key,cmd

" ========================================================================= }}}
" 14 editing text ========================================================= {{{

if has('persistent_undo')
  set undolevels=1000
  if exists('&undoreload')
    set undoreload=10000
  endif
endif

" set complete=.,w,b,u,t
set completeopt+=menuone,longest
set backspace=indent,eol,start
set whichwrap+=<>[]
set textwidth=72
set formatoptions=qrn1
set formatlistpat=^\\s*[0-9*-]\\+[\\]:.)}\\t\ ]\\s*
set showmatch

" ========================================================================= }}}
" 15 tabs and indenting =================================================== {{{

filetype indent on
set smartindent
set smarttab
set tabstop=2
set shiftwidth=2
set expandtab
set cinoptions+=(0

" ========================================================================= }}}
" 16 folding ============================================================== {{{

set foldenable
set foldmethod=manual
set foldlevelstart=99 " Don't autofold anything
set foldlevel=99    " Don't autofold anything

function! MyFoldText()
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart(' ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
  return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction
set foldtext=MyFoldText()

" ========================================================================= }}}
" 17 diff mode ============================================================ {{{


" ========================================================================= }}}
" 18 mapping ============================================================== {{{

let mapleader = ","
let maplocalleader = "\\"

set notimeout
set ttimeout
set ttimeoutlen=10

noremap  <F1> :checktime<cr>
inoremap <F1> <esc>:checktime<cr>

" Keep search matches in the middle of the window
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

nnoremap <leader><space> :let @/ = ""<cr>
nnoremap <tab> %
vnoremap <tab> %
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>
vnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>
" nnoremap / /\v
" vnoremap / /\v

" Visual Mode */# from Scrooloose

function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Y behaves more like I'd expect
nnoremap Y y$

" Typos
command! -bang E e<bang>
command! -bang Q q<bang>
command! -bang W w<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wq wq<bang>
command! -bang WQ wq<bang>

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap <Up> gk
noremap <Down> gj
noremap k gk
noremap j gj
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" I suck at typing.
vnoremap - =

nnoremap U <c-r>

" clean trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" wrap a paragraph
vnoremap Q gq
nnoremap Q gqap

" retain selection when changing indent level
vnoremap < <gv
vnoremap > >gv

" reselect what was just pasted
nnoremap <leader>v V`]

" quickly open .vimrc as split window
nnoremap <leader>ev :exec 'edit ' . resolve(expand($MYVIMRC))<CR>

" switch splits more easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" move lines with leader-{j,k}, indent with leader-{h,l}

nnoremap <leader>k :m-2<CR>==
nnoremap <leader>j :m+<CR>==
nnoremap <leader>h <<
nnoremap <leader>l >>

inoremap <leader>j <Esc>:m+<CR>==gi
inoremap <leader>k <Esc>:m-2<CR>==gi
inoremap <leader>h <Esc><<`]a
inoremap <leader>l <Esc>>>`]a

vnoremap <leader>j :m'>+<CR>gv=gv
vnoremap <leader>k :m-2<CR>gv=gv
vnoremap <leader>h <gv
vnoremap <leader>l >gv

" clear old search
nnoremap <leader>/ :let @/ = ""<CR>

" display unprintable characters
nnoremap <F2> :set list!<CR>

" toggle spellcheck
nnoremap <F4> :set spell!<CR>

" sort CSS
nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

noremap <F7>  :NERDTreeFind<CR>

noremap <leader>o :CtrlPMixed<CR>
noremap <leader>p :CtrlP<CR>
noremap <leader>b :CtrlPBuffer<CR>
noremap <leader>u :CtrlPUndo<CR>
noremap <leader>T :CtrlPTag<CR>
noremap <leader>t :CtrlPBufTagAll<CR>
noremap <leader>m :CtrlPMRUFiles<CR>

noremap <F8> :TagbarToggle<CR>

nnoremap <Leader>aa       :Tabularize argument_list<CR>
vnoremap <Leader>aa       :Tabularize argument_list<CR>

nnoremap <Leader>a<Space> :Tabularize multiple_spaces<CR>
vnoremap <Leader>a<Space> :Tabularize multiple_spaces<CR>

nnoremap <Leader>a&       :Tabularize /&<CR>
vnoremap <Leader>a&       :Tabularize /&<CR>

nnoremap <Leader>a=       :Tabularize /=<CR>
vnoremap <Leader>a=       :Tabularize /=<CR>

nnoremap <Leader>a:       :Tabularize /:\zs/l0r1<CR>
vnoremap <Leader>a:       :Tabularize /:\zs/l0r1<CR>

nnoremap <Leader>a,       :Tabularize /,\zs/l0r1<CR>
vnoremap <Leader>a,       :Tabularize /,\zs/l0r1<CR>

nnoremap <Leader>a<Bar>   :Tabularize /<Bar><CR>  " bar is pipe
vnoremap <Leader>a<Bar>   :Tabularize /<Bar><CR>

nnoremap <leader>* :Ack! -i '\b<c-r><c-w>\b'<cr> " ack word under cursor
nnoremap <leader>8 :Ack! -i '\b<c-r><c-w>\b'<cr> " ack word under cursor
nnoremap <leader>g* :Ack! -i '<c-r><c-w>'<cr> " fuzzy ack word under cursor
nnoremap <leader>g8 :Ack! -i '<c-r><c-w>'<cr> " fuzzy ack word under cursor

" folding (if enabled)
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf

nnoremap <c-c> :Pulse<cr>

cnoreabbrev <expr> ack ((getcmdtype() is# ':' && getcmdline() is# 'ack')?('Ack'):('ack'))
cnoreabbrev <expr> git ((getcmdtype() is# ':' && getcmdline() is# 'git')?('Git'):('git'))

" Column scroll-binding on <leader>sb
noremap <silent> <leader>sb :<C-u>let @z=&so<CR>:set so=0 noscb<CR>:bo vs<CR>Ljzt:setl scb<CR><C-w>p:setl scb<CR>:let &so=@z<CR>

" I don't use 's' anyways, so let's use it for vim-surround
nmap s ys
nmap S yS
vmap s S
vmap gs gS

" ========================================================================= }}}
" 19 reading and writing files ============================================ {{{

set modeline
set backup
set writebackup
set backupdir=~/.vim/local/backup//
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), "p")
endif
set backupskip=/tmp/*,/private/tmp/*"
set fsync
set autowrite
set autowriteall
set autoread
set writeany

if exists('&cryptmethod')
  set cryptmethod=blowfish
endif

" ========================================================================= }}}
" 20 the swap file ======================================================== {{{

set directory=~/.vim/local/swap//
if !isdirectory(expand(&directory))
  call mkdir(expand(&directory), "p")
endif
set updatecount=10
set updatetime=500

" ========================================================================= }}}
" 21 command line editing ================================================= {{{

set wildmenu
set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe,target,tags,.tags
set wildignore+=*.pyc,*.DS_Store,*.db
set history=5000

if has('persistent_undo')
  set undofile
  set undodir=~/.vim/local/undo//
  if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
  endif
  set undolevels=10000
endif

" ========================================================================= }}}
" 22 executing external commands ========================================== {{{

if executable('ag')
  set grepprg=ag\ --vimgrep
  set grepformat=%f:%l:%c:%m
  cnoreabbrev <expr> ag grep
endif

"set nowarn

" ========================================================================= }}}
" 23 running make and jumping to errors =================================== {{{

if has('autocmd')
  augroup QuickFix
    au!
    au BufReadPost quickfix setlocal nolist
  augroup END
endif

" ========================================================================= }}}
" 24 language specific ==================================================== {{{

set iskeyword-=:

" ========================================================================= }}}
" 25 multi-byte characters ================================================ {{{

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

" ========================================================================= }}}
" 26 various ============================================================== {{{

set virtualedit+=block,onemore
set viewoptions-=folds

" set gdefault
if exists('&viewdir')
  set viewdir=~/.vim/local/view//
  if !isdirectory(expand(&viewdir))
    call mkdir(expand(&viewdir), "p")
  endif
endif

set viminfo^=h


if has('autocmd')
  augroup RedrawOnResize
    au!
    au VimResized * silent! redraw!
  augroup END

  augroup RememberLastView
    au!
    au BufWinLeave * silent! mkview "make vim save view (state) (folds, cursor, etc)
    au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
  augroup END

  augroup Stdin
    au!
    au StdinReadPost * :set buftype=nofile
  augroup END
endif

function! s:Pulse()
  execute 'syntax sync fromstart'
  execute 'redraw!'

  redir => old_hi
    silent execute 'hi CursorLine'
  redir END
  let old_hi = split(old_hi, '\n')[0]
  let old_hi = substitute(old_hi, 'xxx', '', '')

  let steps = 12
  let width = 1
  let start = width
  let end = steps * width
  let color = 233

  for i in range(start, end, width)
    execute "hi CursorLine ctermbg=" . (color + i)
    redraw
    sleep 5m
  endfor
  for i in range(end, start, -1 * width)
    execute "hi CursorLine ctermbg=" . (color + i)
    redraw
    sleep 5m
  endfor

  execute 'hi ' . old_hi
endfunction
command! -nargs=0 Pulse call s:Pulse()

" NERDTree settings
let NERDTreeMinimalUI                   = 1
let g:NERDTreeDirArrowExpandable        = '▸'
let g:NERDTreeDirArrowCollapsible       = '▾'
let NERDTreeHijackNetrw                 = 0
let NERDTreeShowBookmarks               = 0
let NERDTreeIgnore                      = ['\.pyc', '\~$', '\.swo$', '\.swp$', '.DS_Store', '\.git', '\.hg', '\.svn', '\.bzr', 'target', 'tags', '.tags']
let NERDTreeChDirMode                   = 0
let NERDTreeQuitOnOpen                  = 0
let NERDTreeMouseMode                   = 1
let NERDTreeShowHidden                  = 1
let NERDTreeKeepTreeInNewTab            = 1
let g:nerdtree_tabs_open_on_gui_startup = 0
let NERDChristmasTree                   = 1
let NERDTreeAutoCenter                  = 0

" CtrlP settings
let g:ctrlp_extensions         = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript', 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
let g:ctrlp_cmd                = 'CtrlPMixed'
let g:ctrlp_match_window       = 'bottom,order:btt,min:1,max:10'
let g:ctrlp_mruf_relative      = 1

if filereadable(expand('~/.local/bin/ctags'))
  let g:ctrlp_buftag_ctags_bin = expand('~/.local/bin/ctags')
endif

let g:ctrlp_tjump_only_silent = 1
nnoremap <c-]> :CtrlPtjump<cr>
vnoremap <c-]> :CtrlPtjumpVisual<cr>

" match with vim-haystack
" function! CtrlPMatch(items, str, limit, mmode, ispath, crfile, regex) abort
"   let items = copy(a:items)
"   if a:ispath
"   call filter(items, 'v:val !=# a:crfile')
"   endif
"   return haystack#filter(items, a:str)
" endfunction
" let g:ctrlp_match_func = {'match': function('CtrlPMatch')}

if executable('ag')
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command =
    \ 'ag %s -i --nocolor --nogroup --hidden
    \ --ignore .git
    \ --ignore target
    \ --ignore tags
    \ --ignore .tags
    \ --ignore .m2
    \ --ignore .svn
    \ --ignore .hg
    \ --ignore .DS_Store
    \ --ignore "**/*.pyc"
    \ -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  " let g:ctrlp_use_caching = 0
endif

" Syntastic settings
let g:syntastic_error_symbol         = '→'
let g:syntastic_warning_symbol       = '→'
"let g:syntastic_python_checker_args = '--ignore=E501'
let syntastic_python_flake8_args     = '--ignore=E501'
let g:syntastic_auto_loc_list        = 1
let g:syntastic_loc_list_height      = 3

let g:syntastic_scala_checkers       = [ 'fsc' ]
let g:syntastic_mode_map             = { 'mode': 'passive', 'active_filetypes': ['scala', 'java'] }
" let g:syntastic_debug              = 63
" let g:syntastic_java_javac_autoload_maven_classpath = 0

if has('autocmd')
  function! FindClasspath(where)
    let cpf = findfile('.classpath', escape(a:where, ' ') . ';')
    let sep = syntastic#util#isRunningWindows() || has('win32unix') ? ';' : ':'
    try
      return cpf !=# '' ? [ '-classpath', join(readfile(cpf), sep) ] : []
    catch
      return []
    endtry
  endfunction

  let g:syntastic_scala_fsc_args = [
    \ '-Xfatal-warnings:false',
    \ '-Xfuture',
    \ '-Xlint',
    \ '-Ywarn-adapted-args',
    \ '-Ywarn-dead-code', 
    \ '-Ywarn-inaccessible',
    \ '-Ywarn-infer-any',
    \ '-Ywarn-nullary-override',
    \ '-Ywarn-nullary-unit',
    \ '-Ywarn-numeric-widen',
    \ '-Ywarn-unused-import',
    \ '-Ywarn-value-discard',
    \ '-deprecation',
    \ '-encoding', 'UTF-8',
    \ '-feature',
    \ '-language:existentials',
    \ '-language:higherKinds', 
    \ '-language:implicitConversions',
    \ '-unchecked',
    \ '-d', ($TMPDIR !=# '' ? $TMPDIR : '/tmp') ]

  augroup syntastic_fsc
    autocmd!
    autocmd FileType scala let b:syntastic_scala_fsc_args =
      \ get(g:, 'syntastic_scala_fsc_args', []) +
      \ FindClasspath(expand('<afile>:p:h', 1))
  augroup END
endif

" Ack settings
if executable('ag')
  let g:ackprg = 'ag --smart-case --nogroup --nocolor --column'
endif

" Airline settings
let g:airline_theme           = 'base16'
let g:airline_powerline_fonts = 1
" let g:airline_left_sep      = ''
" let g:airline_left_sep      = ''
" let g:airline_right_sep     = ''
" let g:airline_right_sep     = ''

let g:airline#extensions#tabline#enabled       = 1
let g:airline#extensions#tabline#show_buffers  = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#close_symbol  = '×'
let g:airline#extensions#tabline#formatter     = 'unique_tail_improved'
let g:airline#extensions#tabline#tab_nr_type   = 1

" vim signature
" let g:SignatureEnabledAtStartup=0

let g:lexima_no_default_rules = 1
call lexima#set_default_rules()
inoremap <expr> <CR> pumvisible() ? neocomplete#close_popup() : lexima#expand('<LT>CR>', 'i')
" call lexima#insmode#map_hook('before', '<cr>', "\<C-r>=neocomplete#close_popup()\<cr>")

" neocomplete
let g:neocomplete#enable_at_startup  = 1
let g:neocomplete#enable_auto_select = 1

" inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

inoremap <expr><Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><Up> pumvisible() ? "\<C-p>" : "\<Up>"

" vim scala
let g:scala_sort_across_groups     = 1
let g:scala_first_party_namespaces = 'simple'


let g:fugitive_github_domains      = ['https://github.banksimple.com']
let g:github_enterprise_urls       = ['https://github.banksimple.com']

" Activation based on file type
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme,scala,java RainbowParentheses
augroup END

" let g:rainbow#max_level = 16
let g:rainbow#pairs = [
                        \ ['{', '}'],
                        \ ['(', ')'],
                        \ ['[', ']']
                    \ ]

" List of colors that you do not want. ANSI code or #RRGGBB
let g:rainbow#blacklist = [
                            \  15,
                            \  7,
                            \  '#c0c5ce',
                            \  '#4f5b66',
                            \  '#d08770',
                            \  '#ab7967'
                        \ ]

" ========================================================================= }}}
" 27 neovim =============================================================== {{{

if has('nvim')
  " let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  tnoremap <Esc> <C-\><C-n>
  " let g:terminal_color_256=1
  let g:terminal_scrollback_buffer_size=100000
endif

" ========================================================================= }}}
" vim: set fdm=marker fdl=1 tw=72 :
