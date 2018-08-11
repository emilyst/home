" default cache with sentinel values
let s:count_cache = {
      \   'pattern':     -1,
      \   'bufnr':       -1,
      \   'changedtick': -1,
      \   'match_count': -1,
      \   'last_run':    -1
      \ }

" gdefault option inverts meaning of 'g' flag on patterns
if &gdefault
  let s:match_command = '%s///ne'
else
  let s:match_command = '%s///gne'
endif

" return 1 if cache is stale, 0 if not
function! <SID>IsCacheStale()
  if s:count_cache['last_run'] == -1
    return 1
  endif

  if has('reltime')
    try
      " gets a list, first of which is seconds since epoch, second of
      " which is micros (not calling reltimefloat for perf reasons)
      let l:time_elapsed = reltime(s:count_cache['last_run'])

      if type(l:time_elapsed) != 3      " anything besides a list means an error occurred
        let s:count_cache['last_run'] = reltime()
        return 1
      elseif l:time_elapsed[0] > 0      " more than a second has elapsed
        let s:count_cache['last_run'] = reltime()
        return 1
      elseif l:time_elapsed[1] > 250000 " more than a quarter of a second has elapsed
        let s:count_cache['last_run'] = reltime()
        return 1
      else                              " less than a quarter of a second has elapsed
        return 0
      endif
    catch
      let s:count_cache['last_run'] = reltime()
      return 1
    endtry
  else
    try
      " not the ideal fallback -- seconds-wise precision only
      let l:time_elapsed = s:count_cache['last_run'] - localtime()

      if l:time_elapsed <= 0
        return 0
      else
        let s:count_cache['last_run'] = localtime()
        return 1
      endif
    catch
      let s:count_cache['last_run'] = localtime()
      return 1
    endtry
  endif
endfunction

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
  " only update if enough time has passed
  if !<SID>IsCacheStale()
    return <SID>GetCachedMatchCount()
  endif

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
" let &statusline='%{GetMatchCount()} %<%f %h%m%r%=%-14.(%l,%c%V%) %P'

" use for airline
call airline#parts#define('match_count', {
      \  'function': 'GetMatchCount'
      \})
let g:airline_section_b = airline#section#create(['match_count'])
