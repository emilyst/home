let s:writing_directory    = expand('~/.local/writing/')
let s:notes_directory      = expand('~/.local/writing/notes/')
let s:work_notes_directory = expand('~/.local/writing/notes/work/')

let s:extension            = '.markdown'
let s:date_format          = '%Y-%m-%d-%H%M%S'

" Convert list of strings to a single string joined by hyphens, all
" lowercased, with anything non-alphabetical or non-numeric turned into
" a hyphen as well
function! s:Slugify(list_of_words)
  return substitute(tolower(join(a:list_of_words, '-')), '\W\+', '-', 'g')
endfunction

" Convenience function to start a new file in the writing repository.
" Filename is a date and time, followed by an optional slug passed to
" the command. If passed in a filename which exists, uses that instead.
function! s:Write(method, directory, ...)
  if !isdirectory(expand(a:directory))
    call mkdir(expand(a:directory), 'p')
  endif

  if a:0 > 0 && filewritable(a:directory . a:1)
    let l:path   = a:directory . a:1
  elseif a:0 > 0
    let l:slug   = '-' . s:Slugify(a:000)
  else
    let l:slug   = ''
  endif

  if !exists('l:path')
    let l:date_prefix = strftime(s:date_format)
    let l:filename    = l:date_prefix . l:slug . s:extension
    let l:path        = a:directory . l:filename
  endif

  if a:method ==? 'n'
    let l:command = 'edit'
  elseif a:method ==? 's'
    let l:command = 'split'
  elseif a:method ==? 'v'
    let l:command = 'vsplit'
  elseif a:method ==? 't'
    let l:command = 'tabedit'
  endif

  execute l:command l:path
endfunction


" :Write =========================================================== {{{

" Returns a list of filenames within the writing directory.
function! s:WritingFileComplete(arg_lead, command_line, cursor_position)
  return map(
        \   split(globpath(s:writing_directory, a:arg_lead . '*'), '\n'),
        \   { k, v -> fnamemodify(v, ':t') }
        \ )
endfunction

" Write commands
command! -complete=customlist,s:WritingFileComplete -nargs=* Write
      \ call s:Write('n', s:writing_directory, <f-args>)
command! -complete=customlist,s:WritingFileComplete -nargs=* WriteV
      \ call s:Write('v', s:writing_directory, <f-args>)
command! -complete=customlist,s:WritingFileComplete -nargs=* WriteS
      \ call s:Write('s', s:writing_directory, <f-args>)
command! -complete=customlist,s:WritingFileComplete -nargs=* WriteT
      \ call s:Write('t', s:writing_directory, <f-args>)

" shortened Write commands
command! -complete=customlist,s:WritingFileComplete -nargs=* W
      \ call s:Write('n', s:writing_directory, <f-args>)
command! -complete=customlist,s:WritingFileComplete -nargs=* WV
      \ call s:Write('v', s:writing_directory, <f-args>)
command! -complete=customlist,s:WritingFileComplete -nargs=* WS
      \ call s:Write('s', s:writing_directory, <f-args>)
command! -complete=customlist,s:WritingFileComplete -nargs=* WT
      \ call s:Write('t', s:writing_directory, <f-args>)

" command abbreviations for mistaken casing or whatever else
cabbrev write  Write
cabbrev writev WriteV
cabbrev writes WriteS
cabbrev writet WriteT
cabbrev Wv     WriteV
cabbrev Ws     WriteS
cabbrev Wt     WriteT
cabbrev wv     WriteV
cabbrev ws     WriteS
cabbrev wt     WriteT

" ================================================================== }}}
" :Note ============================================================ {{{

" Returns a list of filenames within the notes directory.
function! s:NotesFileComplete(arg_lead, command_line, cursor_position)
  return map(
        \   split(globpath(s:notes_directory, a:arg_lead . '*'), '\n'),
        \   { k, v -> fnamemodify(v, ':t') }
        \ )
endfunction

" Note commands
command! -complete=customlist,s:NotesFileComplete -nargs=* Note
      \ call s:Write('n', s:notes_directory, <f-args>)
command! -complete=customlist,s:NotesFileComplete -nargs=* NoteV
      \ call s:Write('v', s:notes_directory, <f-args>)
command! -complete=customlist,s:NotesFileComplete -nargs=* NoteS
      \ call s:Write('s', s:notes_directory, <f-args>)
command! -complete=customlist,s:NotesFileComplete -nargs=* NoteT
      \ call s:Write('t', s:notes_directory, <f-args>)

" shortened Note commands
" cannot make this command, see :help E841
" command! -complete=customlist,s:NotesFileComplete -nargs=* N
"       \ call s:Write('n', s:notes_directory, <f-args>)
command! -complete=customlist,s:NotesFileComplete -nargs=* NV
      \ call s:Write('v', s:notes_directory, <f-args>)
command! -complete=customlist,s:NotesFileComplete -nargs=* NS
      \ call s:Write('s', s:notes_directory, <f-args>)
command! -complete=customlist,s:NotesFileComplete -nargs=* NT
      \ call s:Write('t', s:notes_directory, <f-args>)

" command abbreviations for mistaken casing or whatever else
cabbrev note  Note
cabbrev notev NoteV
cabbrev notes NoteS
cabbrev notet NoteT
cabbrev Nv    NoteV
cabbrev Ns    NoteS
cabbrev Nt    NoteT
cabbrev nv    NoteV
cabbrev ns    NoteS
cabbrev nt    NoteT

" ================================================================== }}}
" :WorkNote ======================================================== {{{

" Returns a list of filenames within the work notes directory.
function! s:WorkNotesFileComplete(arg_lead, command_line, cursor_position)
  return map(
        \   split(globpath(s:work_notes_directory, a:arg_lead . '*'), '\n'),
        \   { k, v -> fnamemodify(v, ':t') }
        \ )
endfunction

" WorkNote commands
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* WorkNote
      \ call s:Write('n', s:work_notes_directory, <f-args>)
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* WorkNoteV
      \ call s:Write('v', s:work_notes_directory, <f-args>)
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* WorkNoteS
      \ call s:Write('s', s:work_notes_directory, <f-args>)
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* WorkNoteT
      \ call s:Write('t', s:work_notes_directory, <f-args>)

" shortened WorkNote commands
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* WN
      \ call s:Write('n', s:work_notes_directory, <f-args>)
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* WNV
      \ call s:Write('v', s:work_notes_directory, <f-args>)
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* WNS
      \ call s:Write('s', s:work_notes_directory, <f-args>)
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* WNT
      \ call s:Write('t', s:work_notes_directory, <f-args>)

" command abbreviations for mistaken casing or whatever else
cabbrev worknote   WorkNote
cabbrev worknotev  WorkNoteV
cabbrev worknotes  WorkNoteS
cabbrev worknotet  WorkNoteT
cabbrev work       WorkNote
cabbrev Work       WorkNote
cabbrev workv      WorkNoteV
cabbrev works      WorkNoteS
cabbrev workt      WorkNoteT
cabbrev wnote      WorkNote
cabbrev wnotev     WorkNoteV
cabbrev wnotes     WorkNoteS
cabbrev wnotet     WorkNoteT
cabbrev Wn         WorkNote
cabbrev WNv        WorkNoteV
cabbrev WNs        WorkNoteS
cabbrev WNt        WorkNoteT
cabbrev wn         WorkNote
cabbrev wnv        WorkNoteV
cabbrev wns        WorkNoteS
cabbrev wnt        WorkNoteT

" ================================================================== }}}

" vim: set fen fdm=marker vop-=folds tw=72 :
