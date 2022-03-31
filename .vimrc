" 0 preamble ============================================================== {{{

" My ".vimrc" contains configures options which are core to Vim and are
" enumerated by the `:options` command. It groups the options into the
" same sections given by that command and in the same order for
" reference.
"
" Occasionally, each section contains other mappings or variable
" settings relevant to the options adjacent to them.
"
" The "$HOME/.vim" directory contains everything else, either as
" individual plugins (under "$HOME/.vim/[after/]{plugin,ftplugin}/") or
" as packages (under under "$HOME/.vim/pack/*/").

set all&  " set all options to their defaults

" ========================================================================= }}}
" 1 important ============================================================= {{{

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
set noautochdir
set wrapscan
set magic
set regexpengine=1  " hopefully faster than 2?
set ignorecase
set smartcase
set gdefault
set incsearch

" ========================================================================= }}}
" 3 tags ================================================================== {{{

set noshowfulltag
set tags+=./tags,./.tags,tags,.tags
set tagcase=followscs

" ========================================================================= }}}
" 4 displaying text ======================================================= {{{

set scroll=7
set scrolloff=0
set nowrap
set linebreak
set display=lastline

if has('windows') && has('folding')
  set fillchars=           " clear defaults
  set fillchars+=stl:\     " set blank space for statusline fill
  set fillchars+=stlnc:\   " set blank space for statusline fill
  set fillchars+=vert:\    " set blank space for vertical separator fill
  set fillchars+=fold:\    " set blank space for foldtext fill
  set fillchars+=diff:\    " set blank space for diff deleted lines fill
endif

set lazyredraw

" see also custom highlights below
set nolist                 " hide non-printing characters
set listchars=             " clear defaults
set listchars+=tab:→\ "    " show a small arrow for a tab
set listchars+=space:·     " show non-trailing spaces as a small dot
set listchars+=lead:·      " show leading whitespace as a small dot
set listchars+=trail:•     " show a small interpunct for trailing whitespace
set listchars+=nbsp:␣      " show a small open box for non-breaking spaces
set listchars+=precedes:«  " show a small double-chevron for text to the left
set listchars+=extends:»   " show a small double-chevron for text to the right
set listchars+=eol:␤       " show newline symbol at the end of a line

set number
set numberwidth=5

" ========================================================================= }}}
" 5 syntax, highlighting and spelling ===================================== {{{

set background=dark
colorscheme nord

syntax enable
syntax sync minlines=256
set synmaxcol=300  " stop syntax highlighting this many columns out

set hlsearch

if has('guicolors')
  set guicolors
endif

if has('termguicolors') && exists('$COLORTERM') && $COLORTERM ==? 'truecolor'
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set cursorline
set cursorlineopt=screenline,number
set colorcolumn=

" if exists('&colorcolumn')
"   let &colorcolumn=join([73,81] + range(101,999), ',')
" endif

" custom highlights

" " show special/nontext chars only on selection (see :help 'listchars')
" " note that this messes up any non-selected background when it's not the
" " same as the Normal background (e.g., diffs)
" highlight clear SpecialKey
" highlight clear NonText
" highlight SpecialKey guifg=bg
" highlight NonText    guifg=bg

highlight Comment        term=italic      cterm=italic      gui=italic
highlight Keyword        term=bold        cterm=bold        gui=bold
highlight Conditional    term=bold        cterm=bold        gui=bold
highlight Define         term=bold        cterm=bold        gui=bold

highlight htmlItalic     term=italic      cterm=italic      gui=italic
highlight htmlBold       term=bold        cterm=bold        gui=bold
highlight htmlBoldItalic term=bold        cterm=bold        gui=bold

match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'  " highlight VCS conflict markers
match ErrorMsg 'd41d8cd9-8f00-3204-a980-0998ecf8427e'  " highlight empty UUID

" ========================================================================= }}}
" 6 multiple windows ====================================================== {{{

set laststatus=2
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

" allow using iterm cursor guide
if exists('$LC_TERMINAL') && $LC_TERMINAL ==? 'iterm2'
  " let &t_ti .= "\<Esc>]1337;HighlightCursorLine=true\x7"
  " let &t_te .= "\<Esc>]1337;HighlightCursorLine=false\x7"
endif

"set ttyscroll=0
if exists('&ttyfast') | set ttyfast | endif

set title titlestring=%<%F%=%l/%L-%P titlelen=70

" ========================================================================= }}}
" 9 using the mouse ======================================================= {{{

" mouse settings are primarily delegated to the terminus plugin

" block select with control-click-and-drag
noremap <C-LeftMouse> <LeftMouse><C-V>
noremap <C-LeftDrag>  <LeftDrag>

" ========================================================================= }}}
" 10 GUI ================================================================== {{{

" this section only appears in `:options` in a GUI like MacVim or gVim

if has('gui_running')
  set linespace=2
  set columnspace=1
  set guifont=SF\ Mono:h13
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
set ruler

" ========================================================================= }}}
" 13 selecting text ======================================================= {{{

if has('clipboard')
  set clipboard=unnamed
endif

"set selectmode+=mouse,key,cmd

" ========================================================================= }}}
" 14 editing text ========================================================= {{{

if has('persistent_undo')
  set undolevels=10000

  if exists('&undoreload')
    set undoreload=10000
  endif

  set undofile
  set undodir=~/.vim/local/undo//
  if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
  endif
endif

set backspace=indent,eol,start
" prefer .vim/after/plugin/mucomplete-configuration.vim
" set complete=.,w,b,u,t
" set completeopt+=menuone,noselect
set whichwrap+=<>[]
set textwidth=72
set formatoptions=qrn1
set formatlistpat=^\\s*[0-9*-]\\+[\\]:.)}\\t\ ]\\s*
" set showmatch
set nojoinspaces  " I only space once after a dot right now

" ========================================================================= }}}
" 15 tabs and indenting =================================================== {{{

filetype indent plugin on

" these are merely defaults
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab
set smartindent
set cinoptions+=(0

" ========================================================================= }}}
" 16 folding ============================================================== {{{

set foldenable
set foldlevel=99      " Don't autofold anything
set foldlevelstart=99 " Don't autofold anything
set foldmethod=manual " allows faster editing by default

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

if v:version > 801
  " set diffopt+=foldcolumn:0
  " set diffopt+=algorithm:histogram
  " set diffopt+=indent-heuristic
endif

" ========================================================================= }}}
" 18 mapping ============================================================== {{{

set notimeout
set ttimeout
set timeoutlen=100
set ttimeoutlen=100

let mapleader = ","
let maplocalleader = "\\"

" someday migrate all the mappings to their own topical plugins

" Keep search matches in the middle of the window
" nnoremap n nzzzv
" nnoremap N Nzzzv

" Same when jumping around
" nnoremap g; g;zz
" nnoremap g, g,zz
" nnoremap <c-o> <c-o>zz

" remappable because of matchit.vim
nmap <tab> %
vmap <tab> %

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
" noremap <Up> gk
" noremap <Down> gj
" noremap k gk
" noremap j gj
" inoremap <Down> <C-o>gj
" inoremap <Up> <C-o>gk

nnoremap U <c-r>

" clean trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
nnoremap <leader>ww :%s/\s\+$//<cr>:let @/=''<CR>

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
nnoremap <leader>/       :silent let @/ = ''<cr>
nnoremap <leader><space> :silent let @/ = ''<cr>

" " quickly create or toggle folds with the spacebar
" nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
" vnoremap <Space> zf

cnoreabbrev <expr> git ((getcmdtype() is# ':' && getcmdline() is# 'git')?('Git'):('git'))

" Column scroll-binding on <leader>sb
noremap <silent> <leader>sb :<C-u>let @z=&so<CR>:set so=0 noscb<CR>:bo vs<CR>Ljzt:setl scb<CR><C-w>p:setl scb<CR>:let &so=@z<CR>

" ========================================================================= }}}
" 19 reading and writing files ============================================ {{{

set modeline
set writebackup
set backup
set backupcopy=yes  " preserves attributes, including Finder file labels

set backupdir=~/.vim/local/backup//
if !isdirectory(expand(&backupdir))
  call mkdir(expand(&backupdir), "p")
endif

set backupskip+=/tmp/*,/private/tmp/*
let &backupskip .= expand('$HOME') . '/.ssh/*'
set autowriteall
set autoread
set writeany
set fsync

if exists('&cryptmethod') && (v:version > 704 || (v:version == 704 && has('patch401')))
  set cryptmethod=blowfish2
endif

" ========================================================================= }}}
" 20 the swap file ======================================================== {{{

set directory=~/.vim/local/swap//
if !isdirectory(expand(&directory))
  call mkdir(expand(&directory), "p")
endif
set swapsync=fsync
set updatecount=10
set updatetime=500

" ========================================================================= }}}
" 21 command line editing ================================================= {{{

set history=5000
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe,target,tags,.tags,*/.git/*
set wildignore+=*.pyc,*.DS_Store,*.db
set wildignore+=versions/*,cache/*
set fileignorecase
set wildignorecase
set wildmenu

" ========================================================================= }}}
" 22 executing external commands ========================================== {{{

"set nowarn

" ========================================================================= }}}
" 23 running make and jumping to errors =================================== {{{

if executable('rg')
  set grepprg=rg\ --smart-case\ --vimgrep
  set grepformat=%f:%l:%c:%m
  cnoreabbrev <expr> rg grep
elseif executable('ag')
  set grepprg=ag\ --smart-case\ --vimgrep
  set grepformat=%f:%l:%c:%m
  cnoreabbrev <expr> ag grep
endif

" ========================================================================= }}}
" 24 language specific ==================================================== {{{

" ========================================================================= }}}
" 25 multi-byte characters ================================================ {{{

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

" ========================================================================= }}}
" 26 various ============================================================== {{{

set virtualedit=all
set gdefault
set viewoptions=cursor,folds,slash,unix
if exists('&viewdir')
  set viewdir=~/.vim/local/view//
  if !isdirectory(expand(&viewdir))
    call mkdir(expand(&viewdir), "p")
  endif
endif

if !empty($SUDO_USER) && $USER !=# $SUDO_USER
  setglobal viminfo=
endif


" ========================================================================= }}}

" vim: fen fdm=marker vop-=folds tw=72
