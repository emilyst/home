" adapted from http://vim.wikia.com/wiki/Edit_gpg_encrypted_files

set backupskip+=*.gpg
set backupskip+=*.asc

if !executable('gpg')
  finish
endif

let s:gpg_command         = 'gpg '
let s:gpg_options         = ' --quiet --default-recipient-self --use-agent --armor '
let s:gpg_command_postfix = ' 2>/dev/null'

" prevent leaking info and set binary on opening the file
function! s:BeforeReadingEncryptedFile()
  if has('undofile')
    setlocal noundofile
  endif
  setlocal noswapfile

  setlocal binary
endfunction

" decrypt the file, unset binary, and run any BufReadPost autocmds
" matching the file name without the .gpg extension after opening
function! s:AfterReadingEncryptedFile()
  silent execute "'[,']!" . s:gpg_command . s:gpg_options . '--decrypt' . s:gpg_command_postfix
  setlocal nobinary
  execute 'doautocmd BufReadPost ' . expand('%:r')
endfunction

" set binary, encrypt the file, and verify the contents on write
function! s:BeforeWritingEncryptedFile()
  setlocal binary
  silent execute "'[,']!" . s:gpg_command . s:gpg_options . '--encrypt --sign' . s:gpg_command_postfix
endfunction

" undo encryption in the buffer, unset binary after writing file, verify
" the file wrote correctly
function! s:AfterWritingEncryptedFile()
  silent undo
  setlocal nobinary

  call system(s:gpg_command . s:gpg_options . '--list-only --list-packets ' . shellescape(expand('%')))
  if v:shell_error != 0
    echoerr 'Did not encrypt file successfully: ' . shellescape(expand('%'))
  endif
endfunction

if has('autocmd')
  augroup EncryptFilesAutomatically
    autocmd!
    autocmd BufReadPre,FileReadPre     *.gpg,*.asc call s:BeforeReadingEncryptedFile()
    autocmd BufReadPost,FileReadPost   *.gpg,*.asc call s:AfterReadingEncryptedFile()
    autocmd BufWritePre,FileWritePre   *.gpg,*.asc call s:BeforeWritingEncryptedFile()
    autocmd BufWritePost,FileWritePost *.gpg,*.asc call s:AfterWritingEncryptedFile()
  augroup END
endif
