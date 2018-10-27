let s:writing_directory    = expand('~/.local/writing/')
let s:notes_directory      = expand('~/.local/writing/notes/')
let s:work_notes_directory = expand('~/.local/writing/notes/work/')

let s:extension            = '.markdown'
let s:date_format          = '%Y-%m-%d-%H%M%S'

" Convert list of strings to a single string joined by hyphens, all
" lowercased, with anything non-alphabetical or non-numeric turned into
" a hyphen as well.
function! s:Slugify(list_of_words) abort
  return substitute(tolower(join(a:list_of_words, '-')), '\W\+', '-', 'g')
endfunction

" Convenience function to start a new file in the writing repository.
" Filename is a date and time, followed by an optional slug passed to
" the command. If passed in a filename which exists, uses that instead.
function! s:Write(method, directory, ...) abort
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

" set up command abbreviation, but only when the line is a command and
" not a search, and only when the abbreviation occurs at the beginning
" of the line
function! AbbreviateCommand(command, abbreviation) abort
  execute "cnoreabbrev <expr> " . a:abbreviation .
        \ " (getcmdtype() == ':' && getcmdline() =~ '^" . a:abbreviation . "$')"
        \ " ? '" . a:command . "' : '" . a:abbreviation . "'"
endfunction


" :Write =========================================================== {{{

" returns a list of filenames within the writing directory
function! s:WritingFileComplete(arg_lead, command_line, cursor_position)
  return map(globpath(s:writing_directory, '*' . a:arg_lead . '*', 0, 1, 1),
        \    { k, v -> fnamemodify(v, ':t') })
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

" command abbreviations for mistaken casing or whatever else
call AbbreviateCommand('Write',  'W')
call AbbreviateCommand('Write',  'write')
call AbbreviateCommand('WriteS', 'WS')
call AbbreviateCommand('WriteS', 'Ws')
call AbbreviateCommand('WriteS', 'writes')
call AbbreviateCommand('WriteS', 'ws')
call AbbreviateCommand('WriteT', 'WT')
call AbbreviateCommand('WriteT', 'Wt')
call AbbreviateCommand('WriteT', 'writet')
call AbbreviateCommand('WriteT', 'wt')
call AbbreviateCommand('WriteV', 'WV')
call AbbreviateCommand('WriteV', 'Wv')
call AbbreviateCommand('WriteV', 'writev')
call AbbreviateCommand('WriteV', 'wv')

" ================================================================== }}}
" :Note ============================================================ {{{

" returns a list of filenames within the notes directory
function! s:NotesFileComplete(arg_lead, command_line, cursor_position) abort
  return map(globpath(s:notes_directory, '*' . a:arg_lead . '*', 0, 1, 1),
        \    { k, v -> fnamemodify(v, ':t') })
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

" command abbreviations for mistaken casing or whatever else
call AbbreviateCommand('Note ', 'N')
call AbbreviateCommand('Note ', 'note')
call AbbreviateCommand('NoteS', 'NS')
call AbbreviateCommand('NoteS', 'Ns')
call AbbreviateCommand('NoteS', 'notes')
call AbbreviateCommand('NoteS', 'ns')
call AbbreviateCommand('NoteT', 'NT')
call AbbreviateCommand('NoteT', 'Nt')
call AbbreviateCommand('NoteT', 'notet')
call AbbreviateCommand('NoteT', 'nt')
call AbbreviateCommand('NoteV', 'NV')
call AbbreviateCommand('NoteV', 'Nv')
call AbbreviateCommand('NoteV', 'notev')
call AbbreviateCommand('NoteV', 'nv')

" ================================================================== }}}
" :WorkNote ======================================================== {{{

" returns a list of filenames within the work notes directory
function! s:WorkNotesFileComplete(arg_lead, command_line, cursor_position) abort
  return map(globpath(s:work_notes_directory, '*' . a:arg_lead . '*', 0, 1, 1),
        \    { k, v -> fnamemodify(v, ':t') })
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

" command abbreviations for mistaken casing or whatever else
call AbbreviateCommand('WorkNote',  'WN')
call AbbreviateCommand('WorkNote',  'Wn')
call AbbreviateCommand('WorkNote',  'Work')
call AbbreviateCommand('WorkNote',  'wn')
call AbbreviateCommand('WorkNote',  'wnote')
call AbbreviateCommand('WorkNote',  'work')
call AbbreviateCommand('WorkNote',  'worknote')
call AbbreviateCommand('WorkNoteS', 'WNs')
call AbbreviateCommand('WorkNoteS', 'WS')
call AbbreviateCommand('WorkNoteS', 'Wns')
call AbbreviateCommand('WorkNoteS', 'wnotes')
call AbbreviateCommand('WorkNoteS', 'wns')
call AbbreviateCommand('WorkNoteS', 'worknotes')
call AbbreviateCommand('WorkNoteS', 'works')
call AbbreviateCommand('WorkNoteT', 'WNt')
call AbbreviateCommand('WorkNoteT', 'WT')
call AbbreviateCommand('WorkNoteT', 'Wnt')
call AbbreviateCommand('WorkNoteT', 'wnotet')
call AbbreviateCommand('WorkNoteT', 'wnt')
call AbbreviateCommand('WorkNoteT', 'worknotet')
call AbbreviateCommand('WorkNoteT', 'workt')
call AbbreviateCommand('WorkNoteV', 'WNv')
call AbbreviateCommand('WorkNoteV', 'WV')
call AbbreviateCommand('WorkNoteV', 'Wnv')
call AbbreviateCommand('WorkNoteV', 'wnotev')
call AbbreviateCommand('WorkNoteV', 'wnv')
call AbbreviateCommand('WorkNoteV', 'worknotev')
call AbbreviateCommand('WorkNoteV', 'workv')

" ================================================================== }}}

" vim: set fen fdm=marker vop-=folds tw=72 :
