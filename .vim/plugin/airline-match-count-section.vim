" default cache with sentinel values
let s:count_cache = {
      \   'pattern': -1,
      \   'bufnr': -1,
      \   'changedtick': -1,
      \   'match_count': -1
      \ }

" gdefault option inverts meaning of 'g' flag on patterns
if &gdefault
  let s:match_command = '%s///ne'
else
  let s:match_command = '%s///gne'
endif

function! <SID>GetCachedMatchCount()
  let l:pattern = s:count_cache['pattern']
  if @/ == ''
    return ''
  else
    " try to adapt to window width
    if winwidth(0) >= 120
      return s:count_cache['match_count'] . ' matches of /' . l:pattern . '/'
    elseif winwidth(0) < 120 && winwidth(0) >= 100
      return s:count_cache['match_count'] . ' matches'
    else
      return s:count_cache['match_count']
    endif
  endif
endfunction

function! GetMatchCount()
  " use cached values if nothing has changed since the last check
  if s:count_cache['pattern'] == @/
        \ && s:count_cache['bufnr'] == bufnr('%')
        \ && s:count_cache['changedtick'] == b:changedtick
    return <SID>GetCachedMatchCount()
  endif

  " something has changed, so we update the cache
  let s:count_cache['pattern']     = @/
  let s:count_cache['bufnr']       = bufnr('%') " current buffer number
  let s:count_cache['changedtick'] = b:changedtick " buffer change count

  " don't count matches that aren't being searched for
  if @/ == ''
    let s:count_cache['match_count'] = 0
    return ''
  else
    try
      " this trick counts the matches; no output means nothing was found
      let l:match_output = execute(s:match_command)
      if len(l:match_output) > 0
        let l:match_count = split(l:match_output)[0]
      else
        let l:match_count = 0
      endif
      let s:count_cache['match_count'] = l:match_count

      return <SID>GetCachedMatchCount()
    catch
      " just in case
      let s:count_cache['match_count'] = 0
      return <SID>GetCachedMatchCount()
    endtry
  endif
endfunction

" use for a normal statusline
" set ruler
" let &statusline='%{ShowCount()} %<%f %h%m%r%=%-14.(%l,%c%V%) %P'

" use for airline
call airline#parts#define('match_count', {
      \  'function': 'GetMatchCount'
      \})
let g:airline_section_b = airline#section#create(['match_count'])
