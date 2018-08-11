" default cache with sentinel values
let s:count_cache = {
      \   'pattern': '',
      \   'bufnr': -1,
      \   'changedtick': -1,
      \   'match_count': -1
      \ }

function! ShowCount()
  " if neither the buffer nor the pattern have changed, we know the
  " count of matches has not changed, either, so use cached value
  if s:count_cache['pattern'] == @/
        \ && s:count_cache['changedtick'] == b:changedtick
        \ && s:count_cache['bufnr'] == bufnr('%')
    if @/ == ''
      return ''
    else
      let match_count = s:count_cache['match_count']
      if match_count > 1
        return match_count . ' matches for /' . @/ . '/'
      elseif match_count == 1
        return match_count . ' match for /' . @/ . '/'
      else
        return ''
      endif
    endif
  endif

  " either the pattern or the buffer has changed, so cache the new
  " values
  let s:count_cache['pattern'] = @/
  let s:count_cache['changedtick'] = b:changedtick
  let s:count_cache['bufnr'] = bufnr('%')

  " don't count matches that aren't being searched for (if this fails
  " for some reason, we catch exceptions below and do the same thing)
  if @/ == ''
    let s:count_cache['match_count'] = 0
    return ''
  endif

  " remember the view (how everything looked) so we can restore it
  let v = winsaveview()

  try
    " this trick counts the matches and stores whatever in counted
    redir => counted
    silent %s///gne
    redir END

    " trim extraneous
    let match_count = matchstr(counted, '\d\+')

    " cache new figure
    let s:count_cache['match_count'] = match_count

    " return new figure for status bar
    if match_count > 1
      return match_count . ' matches for /' . @/ . '/'
    elseif match_count == 1
      return match_count . ' match for /' . @/ . '/'
    else
      return ''
    endif
  catch
    let s:count_cache['match_count'] = 0
    return ''
  finally
    " restore how everything looked
    call winrestview(v)
  endtry
endfunction

" use for a normal statusline
" set ruler
" let &statusline='%{ShowCount()} %<%f %h%m%r%=%-14.(%l,%c%V%) %P'

call airline#parts#define('matches_count', {'function': 'ShowCount'})
let g:airline_section_b = airline#section#create(['matches_count'])
