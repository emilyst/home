" 0 preamble ============================================================== {{{
"
" My .vimrc contains configures those settings which are core to to Vim
" and are enumerated by the :options command, organized by the same
" sections given by that command and in the same order (hopefully).
" A few variable definitions which relate to those options will live
" near them.
"
" The $HOME/.vim directory contains everything else, either as
" individual Vimscript plugins (under $HOME/.vim/plugin) or as packages
" (under $HOME/.vim/bundle or under $HOME/.vim/*/pack). Anything
" pertaining to the behavior of a specific filetype, or the behavior of
" a specific plugin, will also be defined as a plugin or filetype
" plugin. Mappings will eventually be defined as such as well, until
" everything lives in separate files.
"
" ========================================================================= }}}
" 1 important ============================================================= {{{

set all&
set nocompatible
if has('autocmd')
  au! BufEnter *
endif

" package compat via pathogen
runtime pack/default/start/pathogen/autoload/pathogen.vim
if exists("g:loaded_pathogen")
  execute pathogen#infect()
  execute pathogen#helptags()
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

set display=lastline
set scroll=7
set scrolloff=0
set nowrap
set fillchars+=stl:\ 
set fillchars+=stlnc:\ 
set fillchars+=fold:\ 
set fillchars+=diff:\ 
set fillchars+=vert:\ 
set linebreak
set nolazyredraw

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

if has('termguicolors') && $COLORTERM ==? 'truecolor'
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

let base16colorspace=256
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

hi htmlItalic term=italic cterm=italic gui=italic
hi htmlBold term=bold cterm=bold gui=bold
hi htmlBoldItalic term=italic,bold cterm=italic,bold gui=italic,bold


match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'  " highlight VCS conflict markers
match ErrorMsg 'd41d8cd9-8f00-3204-a980-0998ecf8427e'  " highlight empty UUID

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

" ========================================================================= }}}
" 9 using the mouse ======================================================= {{{

" block select with control-click-and-drag
noremap <C-LeftMouse> <LeftMouse><Esc><C-V>
noremap <C-LeftDrag>  <LeftDrag>

" ========================================================================= }}}
" 10 GUI ================================================================== {{{

if has('gui_running')
  set linespace=1
  set guifont=SF\ Mono:h11
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

set complete=.,w,b,u,t
set completeopt+=menuone,noselect
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
set timeoutlen=100
set ttimeout
set ttimeoutlen=100

" Keep search matches in the middle of the window
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" nnoremap <tab> %
" vnoremap <tab> %

nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>
vnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>

" make search a little easier right away (less escaping)
nnoremap / /\v
vnoremap / /\v

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
nnoremap Q gqip

" retain selection when changing indent level
vnoremap < <gv
vnoremap > >gv

" reselect what was just pasted
nnoremap <leader>v V`]

" quickly open .vimrc
nnoremap <leader>ev :exec 'edit ' . resolve(expand($MYVIMRC))<CR>

" switch splits more easily
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" nnoremap <c-left>  <c-w>h
" nnoremap <c-down>  <c-w>j
" nnoremap <c-up>    <c-w>k
" nnoremap <c-right> <c-w>l

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
nnoremap <leader>/       :silent let @/ = ''<CR>
nnoremap <leader><space> :silent let @/ = ''<cr>

" quickly create or toggle folds with the spacebar
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf

cnoreabbrev <expr> git ((getcmdtype() is# ':' && getcmdline() is# 'git')?('Git'):('git'))

" Column scroll-binding on <leader>sb
noremap <silent> <leader>sb :<C-u>let @z=&so<CR>:set so=0 noscb<CR>:bo vs<CR>Ljzt:setl scb<CR><C-w>p:setl scb<CR>:let &so=@z<CR>

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
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe,target,tags,.tags,*/.git/*
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

if executable('rg')
  set grepprg=rg\ --smart-case\ --vimgrep
  set grepformat=%f:%l:%c:%m
  cnoreabbrev <expr> rg grep
elseif executable('ag')
  set grepprg=ag\ --smart-case\ --vimgrep
  set grepformat=%f:%l:%c:%m
  cnoreabbrev <expr> ag grep
endif

"set nowarn

" ========================================================================= }}}
" 23 running make and jumping to errors =================================== {{{

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

set gdefault

if exists('&viewdir')
  set viewdir=~/.vim/local/view//
  if !isdirectory(expand(&viewdir))
    call mkdir(expand(&viewdir), "p")
  endif
endif

" ========================================================================= }}}
" vim: set fdm=marker fdl=1 tw=72 :
