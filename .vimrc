" ==============================================================================
" clear all inherited settings
" ==============================================================================

set all&          " blank slate
set nocompatible  " we're using Vim, not vi (implied by having a vimrc)


" ==============================================================================
" Pathogen (initial setup)
" ==============================================================================

" exclude modules by version/preference

let g:pathogen_disabled = ['bufexplorer', 'neocomplcache', 'nerdtree-tabs']
if v:version < 702
    let g:pathogen_disabled += ['tagbar', 'neocomplcache',]
endif
if v:version < 703 || !has('python')
    let g:pathogen_disabled += ['jedi-vim', 'gundo']
endif

" bring in Pathogen

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

" ==============================================================================
" general settings
" ==============================================================================

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8                   " utf-8 all the way
set shortmess+=I                         " no intro message
set completeopt+=preview,menuone         " nicer completions menu
if exists('+cryptmethod')
    set cryptmethod=blowfish             " use encryption
endif
let mapleader = ","                      " use comma for commands
"set digraph                             " i don't really need digraphs?
set modeline                             " allow using modelines in files
" set gdefault
set magic                                " magic in patterns (default)
set noshowmode                           " ruler has my mode in it
set showcmd                              " show commands as I type them,
                                         " and selections
set showfulltag                          " completions have even more detail
set showmatch                            " highlight matching brackets
set history=5000                         " lots of history
" set notitle
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
"set ttyscroll=0                         " weird terminal thing
set ttyfast                              " fast terminal connections
set scrolloff=3                          " keep lines above and below
" set sidescroll
" set sidescrolloff=5
set nostartofline                        " stay in same column
set backup                               " keep backups
set writebackup
set backupdir=~/.vim/local/backup//      " keep them safe
set directory=~/.vim/local/swap//        " and out of the way
set backspace=indent,eol,start           " backspace works as you'd expect
set splitbelow                           " new splits go below
" set splitright
set switchbuf=useopen,usetab             " use open buffers when opening file
set viminfo^=%,h                         " remember buffers, not searches
set winminheight=0                       " I can collapse windows
if exists('+relativenumber')
    set relativenumber                   " use relative line numbering...
endif
set number                               " ...and show the current line
set updatetime=500                       " update swap file this often
                                         " and trigger CursorHold events


" ==============================================================================
" appearance
" ==============================================================================

syntax enable
set t_Co=256
set background=dark
let g:solarized_style    = "dark"
let g:solarized_italic   = 0
let g:solarized_diffmode = "high"
colorscheme solarized
set cursorline
"set cursorcolumn
"if exists('+colorcolumn') | set colorcolumn+=80,120 | endif
if exists('+colorcolumn')
    let &colorcolumn=join(range(81,999), ',')
endif

set list
set listchars+=tab:›\ "
set listchars+=trail:·
set listchars+=nbsp:␣
set listchars+=extends:›
set listchars+=precedes:‹
set listchars+=eol:\ "

set fillchars+=stl:\ 
set fillchars+=stlnc:\ 
set fillchars+=fold:\ 
set fillchars+=diff:\ 
set fillchars+=vert:\ 

"set showbreak=→

" gui
if has('gui_running')
    set linespace=1
    set guifont=Inconsolata:h13
    if has('transparency')
        set transparency=0
    endif
endif

" Use a bar-shaped cursor for insert mode, even through tmux.

if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


" ==============================================================================
" custom highlights
" ==============================================================================

" hi LineNr       cterm=bold gui=bold " ctermbg=234 guibg=#222222
" hi SignColumn   cterm=bold gui=bold " ctermbg=234 guibg=#222222
" hi CursorLineNr cterm=bold gui=bold " ctermbg=234 guibg=#222222
" hi CursorLine   ctermbg=234 guibg=#222222
" hi ColorColumn  ctermbg=234 guibg=#222222


" ==============================================================================
" formatting
" ==============================================================================

set nowrap
set whichwrap+=<>[]
set textwidth=80
set formatoptions=qrn1
set lbr
set smartindent
filetype indent on
set virtualedit=all


" ==============================================================================
" clipboard
" ==============================================================================

if has('clipboard')
    set clipboard=unnamed
    if has('xterm_clipboard')
        set clipboard+=unnamedplus
    endif
endif


" ==============================================================================
" undo
" ==============================================================================

if has('persistent_undo')
    set undodir=~/.vim/local/undo/
    set undofile
    set undolevels=1000
    if exists('+undoreload')
        set undoreload=10000
    endif
endif


" ==============================================================================
" folding
" ==============================================================================

set foldenable
set foldmethod=manual
set foldlevelstart=99 " Don't autofold anything
set foldlevel=99      " Don't autofold anything

function! MyFoldText() " {{{
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
endfunction " }}}
set foldtext=MyFoldText()

" folding (if enabled)
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf


" ==============================================================================
" searching
" ==============================================================================

" nnoremap / /\v
" vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %


" ==============================================================================
" spelling
" ==============================================================================

"set spell
set spelllang=en_us


" ==============================================================================
" menu (for command tab-complete)
" ==============================================================================

set wildmenu
set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe
set wildignore+=*.pyc,*.DS_Store,*.db


" ==============================================================================
" status bar
" ==============================================================================

if has('statusline')
    set laststatus=2
    set statusline=%<%f\ " Filename
    set statusline+=%w%h%m%r " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y] " filetype
    set statusline+=\ [%{getcwd()}] " current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%% " Right aligned file nav info
endif


" ==============================================================================
" ruler
" ==============================================================================

if has('cmdline_info')
    set ruler " show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " a ruler on steroids
    set showcmd " show partial commands in status line and selected characters/lines in visual mode
endif


" ==============================================================================
" mouse
" ==============================================================================

if has('mouse')
    set mouse=a
    set mousemodel=popup_setpos
endif


" ==============================================================================
" Shell
" ==============================================================================

function! s:ExecuteInShell(command) " {{{
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>:AnsiEsc<CR>'
    silent! execute 'nnoremap <silent> <buffer> q :q<CR>'
    silent! execute 'AnsiEsc'
    echo 'Shell command ' . command . ' executed.'
endfunction " }}}
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
nnoremap <leader>! :Shell 


" ==============================================================================
" keyboard mappings
" ==============================================================================

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap <Up> gk
noremap <Down> gj
noremap k gk
noremap j gj
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" retain selection when changing indent level
vnoremap < <gv
vnoremap > >gv

" easier to enter ex commands
" nnoremap ; :
" vnoremap ; :

" clean trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" wrap a paragraph
vnoremap Q gq
nnoremap Q gqap

" reselect what was just pasted
nnoremap <leader>v V`]

" quickly open .vimrc as split window
nnoremap <leader>ev :exec 'vsplit ' . resolve(expand($MYVIMRC))<CR>

" toggle special characters
nmap <leader>l :set invlist!<CR>

" Prev/Next Buffer
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>

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

" toggle paste mode
nnoremap <F5> :set invpaste!<CR>
set pastetoggle=<F5>

" Locally (local to block) rename a variable
function! Refactor()
    call inputsave()
    let @z=input("What do you want to rename '" . @z . "' to? ")
    call inputrestore()
endfunction
nnoremap <Leader>rf "zyiw:call Refactor()<cr>mx:silent! norm gd<cr>[{V%:s/<C-R>//<c-r>z/g<cr>`x

" Increment a visual selection (like a column of numbers)
function! Incr()
    let a = line('.') - line("'<")
    let c = virtcol("'<")
    if a > 0
        execute 'normal! '.c.'|'.a."\<C-a>"
    endif
    normal `<
endfunction
vnoremap <C-a> :call Incr()<CR>

" sort CSS
nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

" fold HTML tag
noremap <leader>ft Vatzf

" block select with control-click-and-drag
noremap <C-LeftMouse> <LeftMouse><Esc><C-V>
noremap <C-LeftDrag>  <LeftDrag>


" ==============================================================================
" auto commands
" ==============================================================================

if has('autocmd')
    " settings immediately take effect
    "augroup InstantSettings
    "    au!
    "    au BufWritePost ~/.vimrc :exec 'source ' . resolve(expand($MYVIMRC))
    "augroup END

    augroup RedrawOnResize
        au!
        au VimResized * silent! redraw!
    augroup END

    augroup RememberLastView
        au!
        au BufWinLeave * silent! mkview "make vim save view (state) (folds, cursor, etc)
        au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
    augroup END

    augroup AlwaysRelative
        au!
        au BufEnter *
            \ if &number                            |
            \     if exists('+relativenumber')      |
            \         silent! setl relativenumber   |
            \         silent! setl number           |
            \     endif                             |
            \ endif
    augroup END

    augroup EditCrontabOnOSX
        au!
        au BufEnter /private/tmp/crontab.* setl backupcopy=yes
    augroup END
endif


" ==============================================================================
" RTK
" ==============================================================================

if filereadable('/usr/local/etc/vimrc_files/reasonably_stable_mappings.vim')
    source /usr/local/etc/vimrc_files/reasonably_stable_mappings.vim
endif

if has('autocmd') && executable("touch_handler_cgis")
    augroup TouchHandlerScript
        au!
        au BufWritePost *.* let output = system("touch_handler_cgis")
    augroup END
endif

" workarounds
au! BufEnter *
let $TEST_DB=1


" ==============================================================================
" NERDTree settings
" ==============================================================================

noremap <C-e> :NERDTreeToggle<CR>
noremap <F7>  :NERDTreeToggle<CR>
"noremap <leader>e :NERDTreeFind<CR>
"noremap <leader>nt :NERDTreeFind<CR>

" let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
" let NERDTreeHijackNetrw=0
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
" let NERDTreeMouseMode=3
" let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0
let NERDChristmasTree=1
let NERDTreeAutoCenter=1

if has('autocmd')
    augroup CloseNERDTreeIfLastWindow
        autocmd!
        autocmd BufEnter *
            \ if winnr("$") == 1                      |
            \     if exists("b:NERDTreeType")         |
            \         if b:NERDTreeType == "primary"  |
            \             quit                        |
            \         endif                           |
            \     endif                               |
            \ endif                                   |
    augroup END

    " returns true iff is NERDTree open/active
    function! rc:isNTOpen()
        return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
    endfunction

    " returns true iff focused window is NERDTree window
    function! rc:isNTFocused()
        return -1 != match(expand('%'), 'NERD_Tree') 
    endfunction 

    " calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
    function! rc:syncTree()
        if &modifiable && rc:isNTOpen() && !rc:isNTFocused() && strlen(expand('%')) > 0 && !&diff
            NERDTreeFind
            silent! execute "normal zz"
            wincmd p
        endif
    endfunction

    augroup SyncNERDTree
        au!
        au BufEnter * call rc:syncTree()
    augroup END
endif


" ==============================================================================
" CtrlP settings
" ==============================================================================

noremap <leader>o :CtrlPMixed<CR>
noremap <leader>p :CtrlP<CR>
noremap <leader>b :CtrlPBuffer<CR>
noremap <leader>u :CtrlPUndo<CR>
noremap <leader>T :CtrlPTag<CR>
noremap <leader>t :CtrlPBufTagAll<CR>
noremap <leader>m :CtrlPMRUFiles<CR>

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
                          \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:16'
let g:ctrlp_mruf_relative = 1

if filereadable(expand('~/.local/bin/ctags'))
    let g:ctrlp_buftag_ctags_bin = expand('~/.local/bin/ctags')
endif

if executable('ag')
    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

" ==============================================================================
" TagBar settings
" ==============================================================================

noremap <F8> :TagbarToggle<CR>
noremap <C-t> :TagbarToggle<CR>

if filereadable(expand('~/.local/bin/ctags'))
    let g:tagbar_ctags_bin = expand('~/.local/bin/ctags')
endif
let g:tagbar_autoclose = 0
" let g:tagbar_singleclick = 1
let g:tagbar_iconchars = ['▸','▾']
let g:tagbar_type_perl = {
    \ 'kinds' : [
        \ 'u:use',
        \ 'b:base',
        \ 't:test',
        \ 'd:describe',
        \ 'e:extends',
        \ 'a:attribute',
        \ 'r:role',
        \ 'm:method',
        \ 's:function',
        \ 'c:class'
    \ ]
\ }

" ==============================================================================
" Jedi-vim settings
" ==============================================================================

let g:jedi#squelch_py_warning = 1


" ==============================================================================
" Tabular
" ==============================================================================

nnoremap  <Leader>aa        :Tabularize  argument_list<CR>
vnoremap  <Leader>aa        :Tabularize  argument_list<CR>

nnoremap  <Leader>a<Space> :Tabularize  / /<CR>
vnoremap  <Leader>a<Space> :Tabularize  / /<CR>

nnoremap  <Leader>a&       :Tabularize  /&<CR>
vnoremap  <Leader>a&       :Tabularize  /&<CR>

nnoremap  <Leader>a=       :Tabularize  /=<CR>
vnoremap  <Leader>a=       :Tabularize  /=<CR>

nnoremap  <Leader>a:       :Tabularize  /:<CR>
vnoremap  <Leader>a:       :Tabularize  /:<CR>

nnoremap  <Leader>a::      :Tabularize  /:\zs<CR>
vnoremap  <Leader>a::      :Tabularize  /:\zs<CR>

nnoremap  <Leader>a,       :Tabularize  /,<CR>
vnoremap  <Leader>a,       :Tabularize  /,<CR>

nnoremap  <Leader>a,,      :Tabularize  /,\zs<CR>
vnoremap  <Leader>a,,      :Tabularize  /,\zs<CR>

nnoremap  <Leader>a<Bar>   :Tabularize  /<Bar><CR>
vnoremap  <Leader>a<Bar>   :Tabularize  /<Bar><CR>


" ==============================================================================
" NeoComplCache settings
" ==============================================================================

"let g:neocomplcache_enable_at_startup = 0
" Use smartcase.
"let g:neocomplcache_enable_smart_case = 1
"" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
"" Use underscore completion.
"let g:neocomplcache_enable_underbar_completion = 1
"" Sets minimum char length of syntax keyword.
"let g:neocomplcache_min_syntax_length = 3

"" Enable omni completion
"autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType perl setlocal omnifunc=perlcomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags


" ==============================================================================
" Solarized settings
" ==============================================================================



" ==============================================================================
" Syntastic settings
" ==============================================================================

let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
"let g:syntastic_python_checker_args='--ignore=E501'
let syntastic_python_flake8_args='--ignore=E501'
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=5

let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['perl'] }

" ==============================================================================
" SuperTab settings
" ==============================================================================

let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
    \ ["&omnifunc:<c-x><c-o>", "&completefunc:<c-x><c-u>",]
let g:SuperTabDefaultCompletionType = "context"


" ==============================================================================
" Ack settings
" ==============================================================================

if executable('ag')
    let g:ackprg = 'ag --nogroup --nocolor --column'
endif

cnoreabbrev <expr> ack ((getcmdtype() is# ':' && getcmdline() is# 'ack')?('Ack'):('ack'))

nnoremap <leader>* :Ack! -i '\b<c-r><c-w>\b'<cr> " ack word under cursor
nnoremap <leader>8 :Ack! -i '\b<c-r><c-w>\b'<cr> " ack word under cursor


" ==============================================================================
" Airline settings
" ==============================================================================

let g:airline_solarized_bg = 'light'
let g:airline_theme='solarized'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'π'
let g:airline_symbols.whitespace = '¶'

" ==============================================================================
" Gitgutter settings
" ==============================================================================

hi clear SignColumn
hi link SignColumn LineNr
let g:gitgutter_sign_column_always = 1
" let g:gitgutter_highlight_lines = 1
let g:gitgutter_enabled = 1
