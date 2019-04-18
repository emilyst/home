let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_project_root = [ 'Gemfile', 'Rakefile', 'pom.xml' ]
let g:gutentags_generate_on_empty_buffer = 1
if !isdirectory(expand('~/.vim/local/tags/'))
  call mkdir(expand('~/.vim/local/tags/'), 'p')
endif
let g:gutentags_cache_dir = expand('~/.vim/local/tags/')
let g:gutentags_exclude_filetypes = []
let g:gutentags_ctags_exclude = ['node_modules', 'public', 'tmp']
