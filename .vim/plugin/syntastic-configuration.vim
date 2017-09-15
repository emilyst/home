let g:syntastic_error_symbol         = '→'
let g:syntastic_warning_symbol       = '→'
"let g:syntastic_python_checker_args = '--ignore=E501'
let syntastic_python_flake8_args     = '--ignore=E501'
let g:syntastic_auto_loc_list        = 1
let g:syntastic_loc_list_height      = 3

let g:syntastic_scala_checkers       = [ 'scalac', 'scalastyle' ]
let g:syntastic_mode_map             = { 'mode': 'passive', 'active_filetypes': ['scala', 'java'] }
" let g:syntastic_debug              = 63
" let g:syntastic_java_javac_autoload_maven_classpath = 0

let g:syntastic_scala_scalastyle_jar = '/usr/local/Cellar/scalastyle/0.8.0/libexec/scalastyle_2.11-0.8.0-batch.jar'
let g:syntastic_scala_scalastyle_config_file = '~/.vim/local/etc/scalastyle_config.xml'

if has('autocmd')
  function! FindClasspath(where)
    let cpf = findfile('.classpath', escape(a:where, ' ') . ';')
    let sep = syntastic#util#isRunningWindows() || has('win32unix') ? ';' : ':'
    try
      return cpf !=# '' ? [ '-classpath', join(readfile(cpf), sep) ] : []
    catch
      return []
    endtry
  endfunction

  let g:syntastic_scala_scalac_args = [
    \ '-Xfatal-warnings:false',
    \ '-Xfuture',
    \ '-Xlint',
    \ '-Ywarn-adapted-args',
    \ '-Ywarn-dead-code', 
    \ '-Ywarn-inaccessible',
    \ '-Ywarn-infer-any',
    \ '-Ywarn-nullary-override',
    \ '-Ywarn-nullary-unit',
    \ '-Ywarn-numeric-widen',
    \ '-Ywarn-unused-import',
    \ '-Ywarn-value-discard',
    \ '-deprecation',
    \ '-encoding', 'UTF-8',
    \ '-feature',
    \ '-language:existentials',
    \ '-language:higherKinds', 
    \ '-language:implicitConversions',
    \ '-unchecked',
    \ '-d', ($TMPDIR !=# '' ? $TMPDIR : '/tmp') ]

  " augroup syntastic_fsc
  "   autocmd!
  "   autocmd FileType scala let b:syntastic_scala_fsc_args =
  "     \ get(g:, 'syntastic_scala_scalac_args', []) +
  "     \ FindClasspath(expand('<afile>:p:h', 1))
  " augroup END

  augroup syntastic_scalac
    autocmd!
    autocmd FileType scala let b:syntastic_scala_scalac_args =
      \ get(g:, 'syntastic_scala_scalac_args', []) +
      \ FindClasspath(expand('<afile>:p:h', 1))
  augroup END
endif
