let s:directory = expand('~/.local/writing/')

" Convenience function to start a new note in the writing repository.
" Filename is a date and time, followed by an optional slug passed to
" the command. If passed in a filename which exists, uses that instead.
function! s:Note(method, ...)
  if a:0 > 0 && filewritable(s:directory . a:1)
    let l:path   = s:directory . a:1
  elseif a:0 > 0
    let l:slug   = '-' . substitute(tolower(join(a:000, '-')), '\W\+', '-', 'g')
  else
    let l:slug   = ''
  endif

  if !exists('l:path')
    let l:date_prefix = strftime('%Y-%m-%d-%H%M%S')
    let l:extension   = '.markdown.asc'
    let l:filename    = l:date_prefix . l:slug . l:extension
    let l:path        = s:directory . l:filename
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

" Returns a list of filenames within the directory.
function! s:NoteFileComplete(arg_lead, command_line, cursor_position)
  return map(
        \   split(globpath(s:directory, a:arg_lead . '**'), '\n'),
        \   { k, v -> fnamemodify(v, ':t') }
        \ )
endfunction

command! -complete=customlist,s:NoteFileComplete -nargs=* Note  call s:Note('n', <f-args>)
command! -complete=customlist,s:NoteFileComplete -nargs=* NoteV call s:Note('v', <f-args>)
command! -complete=customlist,s:NoteFileComplete -nargs=* NoteS call s:Note('s', <f-args>)
command! -complete=customlist,s:NoteFileComplete -nargs=* NoteT call s:Note('t', <f-args>)

" can't do this, see :help E841
" command! -nargs=* N  call s:Note('new',      <f-args>)
command! -complete=customlist,s:NoteFileComplete -nargs=* NV call s:Note('v', <f-args>)
command! -complete=customlist,s:NoteFileComplete -nargs=* NS call s:Note('s', <f-args>)
command! -complete=customlist,s:NoteFileComplete -nargs=* NT call s:Note('t', <f-args>)

" weird casing or whatever else
cabbrev note  Note
cabbrev notev NoteV
cabbrev notes NoteS
cabbrev notet NoteT
cabbrev N     Note
cabbrev Nv    NoteV
cabbrev Ns    NoteS
cabbrev Nt    NoteT
cabbrev nv    NoteV
cabbrev ns    NoteS
cabbrev nt    NoteT
