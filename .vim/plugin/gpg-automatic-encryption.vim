" adapted from http://vim.wikia.com/wiki/Edit_gpg_encrypted_files

let s:gpg_options = '--quiet --default-recipient-self --use-agent --armor 2>/dev/null'

set backupskip+=*.gpg
set backupskip+=*.asc

if has('autocmd') && !exists('#EncryptFilesAutomatically')
  augroup EncryptFilesAutomatically
    autocmd!

    " prevent leaking info and set binary on opening the file
    autocmd BufReadPre,FileReadPre *.gpg,*.asc
          \ setlocal noswapfile |
          \ if has('undofile') | setlocal noundofile | endif |
          \ setlocal binary

    " decrypt the file, unset binary, and run any BufReadPost autocmds
    " matching the file name without the .gpg extension after opening
    autocmd BufReadPost,FileReadPost *.gpg,*.asc
      \ silent execute "'[,']!gpg --decrypt " . s:gpg_options |
      \ setlocal nobinary |
      \ execute 'doautocmd BufReadPost ' . expand('%:r')

    " set binary and encrypt the file on writing the file
    autocmd BufWritePre,FileWritePre *.gpg,*.asc
      \ setlocal binary |
      \ silent execute "'[,']!gpg --encrypt --sign " . s:gpg_options

    " undo encryption in the buffer and unset binary after writing file
    autocmd BufWritePost,FileWritePost *.gpg,*.asc
      \ silent u |
      \ setlocal nobinary
  augroup END
endif
