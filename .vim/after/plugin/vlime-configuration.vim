" a lot of this was scammed from steve losh after talking to him and
" then abused and misshapen till it fit me better --
" start at https://bitbucket.org/sjl/dotfiles/src/cf4104b3764edac74f8df0e6e158fca38adac1eb/vim/vimrc#vimrc-2532:2631

let g:vlime_cl_use_terminal = v:true
let g:vlime_contribs = [
        \ "SWANK-ASDF",
        \ "SWANK-PACKAGE-FU",
        \ "SWANK-PRESENTATIONS",
        \ "SWANK-FANCY-INSPECTOR",
        \ "SWANK-C-P-C",
        \ "SWANK-ARGLISTS",
        \ "SWANK-REPL",
        \ "SWANK-FUZZY"
      \ ]

let g:vlime_window_settings = {
        \ "sldb": {
          \ "pos": "belowright",
          \ "vertical": v:false
        \ },
        \ "xref": {
          \ "pos": "belowright",
          \ "size": 5,
          \ "vertical": v:false
        \ },
        \ "repl": {
          \ "pos": "belowright",
          \ "vertical": v:false
        \ },
        \ "inspector": {
          \ "pos": "belowright",
          \ "vertical": v:false
        \ },
        \ "arglist": {
          \ "pos": "topleft",
          \ "size": 2,
          \ "vertical": v:false
        \ }
    \ }

let g:vlime_compiles_policy = {
      \ "DEBUG": 2,
      \ "SAFETY": 3,
      \ "SPEED": 1
      \ }

function! CleanVlimeWindows()
    call vlime#plugin#CloseWindow("preview")
    call vlime#plugin#CloseWindow("notes")
    call vlime#plugin#CloseWindow("xref")
    wincmd =
endfunction

function! MapVlimeKeys()
    nnoremap <silent> <buffer> <c-]> :call vlime#plugin#FindDefinition(vlime#ui#CurAtom())<cr>
    nnoremap <silent> <buffer> -     :call CleanVlimeWindows()<cr>
endfunction

augroup CustomVlimeInputBuffer
    autocmd!
    " autocmd FileType vlime_input inoremap <silent> <buffer> <tab> <c-r>=VlimeKey("tab")<cr>
    "
    autocmd FileType vlime_input setlocal omnifunc=vlime#plugin#CompleteFunc
    autocmd FileType vlime_input setlocal indentexpr=vlime#plugin#CalcCurIndent()
    autocmd FileType vlime_input inoremap <c-n> <c-x><c-o>
augroup end

" normally I'd shove this stuff in ftplugin files, but these are Vlime
" specific things and are easier to group here
augroup LocalVlime
    autocmd!

    " Settings
    autocmd FileType vlime_sldb setlocal nowrap
    autocmd FileType vlime_repl setlocal nowrap winfixheight

    " Keys for Lisp files
    " autocmd FileType lisp setlocal omnifunc=vlime#plugin#CompleteFunc
    autocmd FileType lisp nnoremap <buffer> <localleader>e :call vlime#plugin#Compile(vlime#ui#CurTopExpr(v:true))<cr>
    autocmd FileType lisp nnoremap <buffer> <localleader>f :call vlime#plugin#CompileFile(expand("%:p"))<cr>
    autocmd FileType lisp nnoremap <buffer> <localleader>S :call vlime#plugin#SendToREPL(vlime#ui#CurTopExpr())<cr>
    autocmd FileType lisp nnoremap <buffer> <localleader>i :call vlime#plugin#Inspect(vlime#ui#CurExprOrAtom())<cr>
    autocmd FileType lisp nnoremap <buffer> <nowait> <localleader>I :call vlime#plugin#Inspect()<cr>
    autocmd FileType lisp nnoremap <buffer> M :call vlime#plugin#DocumentationSymbol(vlime#ui#CurAtom())<cr>
    autocmd FileType lisp setlocal indentexpr=vlime#plugin#CalcCurIndent()
    autocmd FileType lisp nnoremap <buffer> gi :call IndentToplevelLispForm()<cr>

    " Keys for the REPL
    autocmd FileType vlime_repl      nnoremap <buffer> i :call vlime#ui#repl#InspectCurREPLPresentation()<cr>
    autocmd FileType vlime_repl      nnoremap <buffer> <2-LeftMouse> :call vlime#ui#repl#InspectCurREPLPresentation()<cr>

    " Keys for the Inspector
    autocmd FileType vlime_inspector nnoremap <buffer> <2-LeftMouse> :call vlime#ui#inspector#InspectorSelect()<cr>

    " Universal keys, for all kinds of Vlime windows
    autocmd FileType lisp,vlime_repl,vlime_inspector,vlime_sldb,vlime_notes,vlime_xref,vlime_preview call MapVlimeKeys()

    " Fix <cr>
    autocmd FileType vlime_xref      nnoremap <buffer> <cr> :call vlime#ui#xref#OpenCurXref()<cr>
    autocmd FileType vlime_notes     nnoremap <buffer> <cr> :call vlime#ui#compiler_notes#OpenCurNote()<cr>
    autocmd FileType vlime_sldb      nnoremap <buffer> <cr> :call vlime#ui#sldb#ChooseCurRestart()<cr>
    autocmd FileType vlime_inspector nnoremap <buffer> <cr> :call vlime#ui#inspector#InspectorSelect()<cr>

    " Fix d
    autocmd FileType vlime_sldb      nnoremap <buffer> <nowait> d :call vlime#ui#sldb#ShowFrameDetails()<cr>

    " Fix s
    autocmd FileType vlime_sldb      nnoremap <buffer> <nowait> s :call vlime#ui#sldb#StepCurOrLastFrame("step")<cr>

    " Fix p
    autocmd FileType vlime_inspector nnoremap <buffer> p :call vlime#ui#inspector#InspectorPop()<cr>
augroup end
