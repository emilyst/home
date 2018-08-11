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

function! ShowCount()
  " use cached values if nothing has changed since the last check
  if s:count_cache['pattern'] == @/
        \ && s:count_cache['bufnr'] == bufnr('%')
        \ && s:count_cache['changedtick'] == b:changedtick
    if @/ == ''
      return ''
    else
      if s:count_cache['match_count'] == 1
        return s:count_cache['match_count'] . ' match for /' . @/ . '/'
      else
        return s:count_cache['match_count'] . ' matches for /' . @/ . '/'
      endif
    endif
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

      if l:match_count == 1
        return l:match_count . ' match for /' . @/ . '/'
      else
        return l:match_count . ' matches for /' . @/ . '/'
      endif
    catch
      " just in case
      let s:count_cache['match_count'] = 0
      return '0 matches for /' . @/ . '/'
    endtry
  endif
endfunction

" use for a normal statusline
" set ruler
" let &statusline='%{ShowCount()} %<%f %h%m%r%=%-14.(%l,%c%V%) %P'

" use for airline
call airline#parts#define('matches_count', {'function': 'ShowCount'})
let g:airline_section_b = airline#section#create(['matches_count'])
