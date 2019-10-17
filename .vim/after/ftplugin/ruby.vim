if exists(":RainbowParentheses")
  RainbowParentheses
endif

if has('autocmd') && !exists('#SetFoldMethod')
  augroup SetFoldMethod
    autocmd!
    " extensions borrowed from ruby/ftdetect/ruby.vim
    autocmd BufWinEnter *.rb                          if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter *.erb                         if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter *.rhtml                       if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter *.irbrc                       if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter *.rbw                         if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter *.gemspec                     if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter *.ru                          if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter Gemfile                       if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter *.builder,*.rxml,*.rjs,*.ruby if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter [rR]akefile,*.rake            if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter [rR]akefile*                  if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
    autocmd BufWinEnter [rR]antfile,*.rant            if &foldmethod != 'indent' | setlocal foldmethod=manual | endif
  augroup END
endif

" attempt to undo whatever Bundler's environment preserver has done
" (see https://github.com/bundler/bundler/blob/master/lib/bundler/environment_preserver.rb)
" works in 8.0.1832 and later (silently fails earlier)
if has('autocmd') && !exists('#UndoBundlerEnvironmentPreserver')
  augroup UndoBundlerEnvironmentPreserver
    autocmd!
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_BUNDLE_BIN_PATH
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_BUNDLE_BIN_PATH
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_BUNDLE_GEMFILE
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_BUNDLER_ORIG_MANPATH
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_BUNDLER_VERSION
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_GEM_HOME
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_GEM_PATH
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_MANPATH
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_PATH
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_RB_USER_INSTALL
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_RUBYLIB
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_RUBYOPT
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $GEM_PATH
    autocmd BufWinEnter,BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $GEM_HOME
  augroup END
endif

if !exists('*UndoBundlerEnvironment')
  function! s:UndoBundlerEnvironment()
    unlet $BUNDLER_ORIG_BUNDLE_BIN_PATH
    unlet $BUNDLER_ORIG_BUNDLE_BIN_PATH
    unlet $BUNDLER_ORIG_BUNDLE_GEMFILE
    unlet $BUNDLER_ORIG_BUNDLER_ORIG_MANPATH
    unlet $BUNDLER_ORIG_BUNDLER_VERSION
    unlet $BUNDLER_ORIG_GEM_HOME
    unlet $BUNDLER_ORIG_GEM_PATH
    unlet $BUNDLER_ORIG_MANPATH
    unlet $BUNDLER_ORIG_PATH
    unlet $BUNDLER_ORIG_RB_USER_INSTALL
    unlet $BUNDLER_ORIG_RUBYLIB
    unlet $BUNDLER_ORIG_RUBYOPT
    unlet $GEM_PATH
    unlet $GEM_HOME
  endfunction
endif

command! -nargs=0 UndoBundlerEnvironment call <SID>UndoBundlerEnvironment()
command! -nargs=0 UndoBundler call <SID>UndoBundlerEnvironment()
command! -nargs=0 Unbundle call <SID>UndoBundlerEnvironment()
command! -nargs=0 Unbun call <SID>UndoBundlerEnvironment()

if exists('g:autoloaded_rails')
  nnoremap <silent> <leader>r :execute ':' . line('.') . 'Rails'<CR>
  nnoremap <silent> <leader>R :execute ':Rails'<CR>
endif


" " wacky shit: read in tags from Ruby system and gems
" if executable('gem')
"       \ && exists('*pathogen#legacyjoin')
"       \ && exists('*pathogen#uniq')
"       \ && exists('*pathogen#split')
"   let gem_tags = trim(system('gem env home')) . '/**/tags'
"   let &l:tags = string(pathogen#legacyjoin(pathogen#uniq(pathogen#split(&tags) + [gem_tags])))
" endif
