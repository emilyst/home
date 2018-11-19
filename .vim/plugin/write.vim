if !has('patch-8.0.1089')  " needed for <range>
  finish
endif

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
function! s:Write(method, directory, line1, line2, range, ...) abort
  " this was used with a visual selection, so grab those lines first
  if a:range > 0
    let l:original_z = @z
    silent execute a:line1 . ',' . a:line2 . 'yank z'
    let l:contents = substitute(@z, '[\r\n]\+$', '', '')
    let @z = l:original_z
  endif

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

  " turn unnamed buffer into the new file if it doesn't already exist
  if bufname('%') == '' && !filereadable(l:path)
    if a:method ==? 'n'
      execute 'saveas' l:path
    elseif a:method ==? 's'
      execute 'split'
      execute 'saveas' l:path
    elseif a:method ==? 'v'
      execute 'vsplit'
      execute 'saveas' l:path
    elseif a:method ==? 't'
      execute 'tabedit'
      execute 'saveas' l:path
    endif
  else                   " start from scratch with a new buffer
    if a:method ==? 'n'
      execute 'edit' l:path
    elseif a:method ==? 's'
      execute 'split' l:path
    elseif a:method ==? 'v'
      execute 'vsplit' l:path
    elseif a:method ==? 't'
      execute 'tabedit' l:path
    endif
  endif

  " insert selected lines if they exist, delete extra line from the end
  " without touching the normal register, and put cursor back at the top
  if exists('l:contents')
    call append(0, split(l:contents, '[\r\n]'))
    execute 'normal G"_ddgg0'
  endif
endfunction

" set up command abbreviation, but only when the line is a command and
" not a search, and only when the abbreviation occurs at the beginning
" of the line
function! s:AbbreviateCommand(command, abbreviation) abort
  execute "cnoreabbrev <expr> " . a:abbreviation .
        \ " (getcmdtype() == ':' && getcmdline() =~ '^" . a:abbreviation . "$')"
        \ " ? '" . a:command . "' : '" . a:abbreviation . "'"
endfunction


" :Write =========================================================== {{{

" returns a list of filenames within the writing directory
function! s:WritingFileComplete(arg_lead, command_line, cursor_position)
  return map(globpath(expand(s:writing_directory) . '**', '*' . a:arg_lead . '*', 0, 1, 1),
        \    { k, v -> fnamemodify(v, ':s?' . expand(s:writing_directory) . '??') })
endfunction

" Write commands
command! -complete=customlist,s:WritingFileComplete -nargs=* -range Write
      \ call s:Write('n', s:writing_directory, <line1>, <line2>, <range>, <f-args>)
command! -complete=customlist,s:WritingFileComplete -nargs=* -range WriteV
      \ call s:Write('v', s:writing_directory, <line1>, <line2>, <range>, <f-args>)
command! -complete=customlist,s:WritingFileComplete -nargs=* -range WriteS
      \ call s:Write('s', s:writing_directory, <line1>, <line2>, <range>, <f-args>)
command! -complete=customlist,s:WritingFileComplete -nargs=* -range WriteT
      \ call s:Write('t', s:writing_directory, <line1>, <line2>, <range>, <f-args>)

" command abbreviations for mistaken casing or whatever else
call s:AbbreviateCommand('Write',  'W')
call s:AbbreviateCommand('Write',  'write')
call s:AbbreviateCommand('WriteS', 'WS')
call s:AbbreviateCommand('WriteS', 'Ws')
call s:AbbreviateCommand('WriteS', 'writes')
call s:AbbreviateCommand('WriteS', 'ws')
call s:AbbreviateCommand('WriteT', 'WT')
call s:AbbreviateCommand('WriteT', 'Wt')
call s:AbbreviateCommand('WriteT', 'writet')
call s:AbbreviateCommand('WriteT', 'wt')
call s:AbbreviateCommand('WriteV', 'WV')
call s:AbbreviateCommand('WriteV', 'Wv')
call s:AbbreviateCommand('WriteV', 'writev')
call s:AbbreviateCommand('WriteV', 'wv')

" ================================================================== }}}
" :Note ============================================================ {{{

" returns a list of filenames within the notes directory
function! s:NotesFileComplete(arg_lead, command_line, cursor_position)
  return map(globpath(expand(s:notes_directory) . '**', '*' . a:arg_lead . '*', 0, 1, 1),
        \    { k, v -> fnamemodify(v, ':s?' . expand(s:notes_directory) . '??') })
endfunction

" Note commands
command! -complete=customlist,s:NotesFileComplete -nargs=* -range Note
      \ call s:Write('n', s:notes_directory, <line1>, <line2>, <range>, <f-args>)
command! -complete=customlist,s:NotesFileComplete -nargs=* -range NoteV
      \ call s:Write('v', s:notes_directory, <line1>, <line2>, <range>, <f-args>)
command! -complete=customlist,s:NotesFileComplete -nargs=* -range NoteS
      \ call s:Write('s', s:notes_directory, <line1>, <line2>, <range>, <f-args>)
command! -complete=customlist,s:NotesFileComplete -nargs=* -range NoteT
      \ call s:Write('t', s:notes_directory, <line1>, <line2>, <range>, <f-args>)

" command abbreviations for mistaken casing or whatever else
call s:AbbreviateCommand('Note ', 'N')
call s:AbbreviateCommand('Note ', 'note')
call s:AbbreviateCommand('NoteS', 'NS')
call s:AbbreviateCommand('NoteS', 'Ns')
call s:AbbreviateCommand('NoteS', 'notes')
call s:AbbreviateCommand('NoteS', 'ns')
call s:AbbreviateCommand('NoteT', 'NT')
call s:AbbreviateCommand('NoteT', 'Nt')
call s:AbbreviateCommand('NoteT', 'notet')
call s:AbbreviateCommand('NoteT', 'nt')
call s:AbbreviateCommand('NoteV', 'NV')
call s:AbbreviateCommand('NoteV', 'Nv')
call s:AbbreviateCommand('NoteV', 'notev')
call s:AbbreviateCommand('NoteV', 'nv')

" ================================================================== }}}
" :WorkNote ======================================================== {{{

" returns a list of filenames within the work notes directory
function! s:WorkNotesFileComplete(arg_lead, command_line, cursor_position)
  return map(globpath(expand(s:work_notes_directory) . '**', '*' . a:arg_lead . '*', 0, 1, 1),
        \    { k, v -> fnamemodify(v, ':s?' . expand(s:work_notes_directory) . '??') })
endfunction

" WorkNote commands
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* -range WorkNote
      \ call s:Write('n', s:work_notes_directory, <line1>, <line2>, <range>, <f-args>)
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* -range WorkNoteV
      \ call s:Write('v', s:work_notes_directory, <line1>, <line2>, <range>, <f-args>)
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* -range WorkNoteS
      \ call s:Write('s', s:work_notes_directory, <line1>, <line2>, <range>, <f-args>)
command! -complete=customlist,s:WorkNotesFileComplete -nargs=* -range WorkNoteT
      \ call s:Write('t', s:work_notes_directory, <line1>, <line2>, <range>, <f-args>)

" command abbreviations for mistaken casing or whatever else
call s:AbbreviateCommand('WorkNote',  'WN')
call s:AbbreviateCommand('WorkNote',  'Wn')
call s:AbbreviateCommand('WorkNote',  'Work')
call s:AbbreviateCommand('WorkNote',  'wn')
call s:AbbreviateCommand('WorkNote',  'wnote')
call s:AbbreviateCommand('WorkNote',  'work')
call s:AbbreviateCommand('WorkNote',  'worknote')
call s:AbbreviateCommand('WorkNoteS', 'WNs')
call s:AbbreviateCommand('WorkNoteS', 'WS')
call s:AbbreviateCommand('WorkNoteS', 'Wns')
call s:AbbreviateCommand('WorkNoteS', 'wnotes')
call s:AbbreviateCommand('WorkNoteS', 'wns')
call s:AbbreviateCommand('WorkNoteS', 'worknotes')
call s:AbbreviateCommand('WorkNoteS', 'works')
call s:AbbreviateCommand('WorkNoteT', 'WNt')
call s:AbbreviateCommand('WorkNoteT', 'WT')
call s:AbbreviateCommand('WorkNoteT', 'Wnt')
call s:AbbreviateCommand('WorkNoteT', 'wnotet')
call s:AbbreviateCommand('WorkNoteT', 'wnt')
call s:AbbreviateCommand('WorkNoteT', 'worknotet')
call s:AbbreviateCommand('WorkNoteT', 'workt')
call s:AbbreviateCommand('WorkNoteV', 'WNv')
call s:AbbreviateCommand('WorkNoteV', 'WV')
call s:AbbreviateCommand('WorkNoteV', 'Wnv')
call s:AbbreviateCommand('WorkNoteV', 'wnotev')
call s:AbbreviateCommand('WorkNoteV', 'wnv')
call s:AbbreviateCommand('WorkNoteV', 'worknotev')
call s:AbbreviateCommand('WorkNoteV', 'workv')

" ================================================================== }}}

" vim: set fen fdm=marker vop-=folds tw=72 :
