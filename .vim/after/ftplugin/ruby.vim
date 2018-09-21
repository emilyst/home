if exists(":RainbowParentheses")
  RainbowParentheses
endif

" attempt to undo whatever Bundler's environment preserver has done
" (see https://github.com/bundler/bundler/blob/master/lib/bundler/environment_preserver.rb)
" works in 8.0.1832 and later (silently fails earlier)
if has('autocmd') && !exists('#UndoBundlerEnvironmentPreserver')
  augroup UndoBundlerEnvironmentPreserver
    autocmd!
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_BUNDLE_BIN_PATH
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_BUNDLE_BIN_PATH
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_BUNDLE_GEMFILE
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_BUNDLER_ORIG_MANPATH
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_BUNDLER_VERSION
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_GEM_HOME
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_GEM_PATH
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_MANPATH
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_PATH
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_RB_USER_INSTALL
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_RUBYLIB
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $BUNDLER_ORIG_RUBYOPT
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $GEM_PATH
    autocmd BufEnter,BufLeave,TextChanged,TextChangedI,TextChangedP *.rb unlet $GEM_HOME
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

" " wacky shit: read in tags from Ruby system and gems
" if executable('gem')
"       \ && exists('*pathogen#legacyjoin')
"       \ && exists('*pathogen#uniq')
"       \ && exists('*pathogen#split')
"   let gem_tags = trim(system('gem env home')) . '/**/tags'
"   let &l:tags = string(pathogen#legacyjoin(pathogen#uniq(pathogen#split(&tags) + [gem_tags])))
" endif
