scriptencoding utf-8

" Author:      Emily St
" Script:      statusline-match-count
" Description: Calculates and displays a statusline item which counts
"              number of times the current search pattern occurs in the
"              current buffer. Written both for vim-airline and for the
"              generic statusline.
" License:     Public domain

if exists('g:loaded_statusline_match_count') || (v:version < 703)
  finish
endif
let g:loaded_statusline_match_count = 1

" gdefault option inverts meaning of 'g' flag on patterns
if &gdefault
  let s:match_command = '%s//&/ne'
else
  let s:match_command = '%s//&/gne'
endif

" max file size before automatically disabling
let s:max_file_size_in_bytes = 10 * 1024 * 1024

" time during which cached values get reused (so we don't drag during,
" e.g., incsearch)
let s:cache_timeout_in_seconds = 0.25

" default sentinel values representing an unused cache
let s:unused_cache_values = {
      \   'pattern':     -1,
      \   'changedtick': -1,
      \   'match_count': -1,
      \   'last_run':    -1
      \ }

" return 1 if cache is stale, 0 if not
function! s:IsCacheStale(count_cache)
  " hit the cache the first time around so there's a brief window when
  " first searching for a pattern before we update the statusline
  if a:count_cache == s:unused_cache_values
    let a:count_cache.last_run = reltime()
    return 0
  endif

  let l:seconds = s:cache_timeout_in_seconds
  let l:micros = s:cache_timeout_in_seconds * 1000000

  if has('reltime')
    try
      " not calling reltimefloat for perf reasons
      let l:time_elapsed = reltime(a:count_cache.last_run)
      if type(l:time_elapsed) != 3          " error (treat as cache miss)
        let a:count_cache.last_run = reltime()
        return 1
      elseif l:time_elapsed[0] > l:seconds  " cache miss (more than a second)
        let a:count_cache.last_run = reltime()
        return 1
      elseif l:time_elapsed[1] > l:micros   " cache miss (less than a second)
        let a:count_cache.last_run = reltime()
        return 1
      else                                  " cache hit
        return 0
      endif
    catch                                   " error (treat as cache miss)
      let a:count_cache.last_run = reltime()
      return 1
    endtry
  else
    try " not the ideal fallback -- seconds-wise precision only
      let l:time_elapsed = a:count_cache.last_run - localtime()
      if l:time_elapsed > l:seconds         " cache miss (more than a second)
        let a:count_cache.last_run = localtime()
        return 1
      else                                  " cache hit
        return 0
      endif
    catch                                   " error (treat as cache miss)
      let a:count_cache.last_run = localtime()
      return 1
    endtry
  endif
endfunction

" use the cache and window width to construct the status string
function! s:GetCachedMatchCount(count_cache)
  if @/ == ''
    return ''
  elseif a:count_cache.match_count == -1
    return 'working...'
  else
    " try to adapt to window width
    if winwidth(0) >= 120
      return a:count_cache.match_count . ' matches of /' . a:count_cache.pattern . '/'
    elseif winwidth(0) < 120 && winwidth(0) >= 100
      return a:count_cache.match_count . ' matches'
    else
      return a:count_cache.match_count
    endif
  endif
endfunction

" return 1 if file is too large to process, 0 if not
" (if match counting has been toggled on manually, we ignore file size)
function! s:IsLargeFile(force)
  if a:force
    return 0
  else
    if getfsize(expand(@%)) >= s:max_file_size_in_bytes
      return 1
    else
      return 0
    endif
  endif
endfunction

" allow forcing on or off match-counting for a buffer (also allows
" overriding the file-size detection, hence the `force` variable)
function! s:ToggleMatchCounting()
  " define buffer variables if not already defined
  let b:match_count_force = get(b:, 'match_count_force', 0)
  let b:match_count_enable = get(b:, 'match_count_enable', 1)

  if b:match_count_force == 0 && b:match_count_enable == 1
    let b:match_count_force = 0
    let b:match_count_enable = 0
    echom 'Match counting disabled for this buffer'
  elseif b:match_count_force == 0 && b:match_count_enable == 0
    let b:match_count_force = 1
    let b:match_count_enable = 1
    echom 'Match counting enabled for this buffer'
  elseif b:match_count_force == 1 && b:match_count_enable == 1
    let b:match_count_force = 0
    let b:match_count_enable = 0
    echom 'Match counting disabled for this buffer'
  else
    " this possibility shouldn't arise, but it's here for completeness
    let b:match_count_force = 1
    let b:match_count_enable = 1
    echom 'Match counting enabled for this buffer'
  endif

  redrawstatus!
endfunction

" calculate the match count
function! GetMatchCount()
  " define buffer variables if not already defined
  let b:match_count_force = get(b:, 'match_count_force', 0)
  let b:match_count_enable = get(b:, 'match_count_enable', 1)

  " do nothing if disabled in this buffer
  if b:match_count_enable == 0 | return '' | endif

  if s:IsLargeFile(b:match_count_force)
    " this allows the force/match variables to match one another for
    " large files so that you can toggle back on right away instead of
    " needing to toggle off first
    if b:match_count_force == 0 && b:match_count_enable == 1
      let b:match_count_enable = 0
    endif
    return ''
  endif

  let b:count_cache = get(b:, 'count_cache', copy(s:unused_cache_values))

  " only update if enough time has passed
  if !s:IsCacheStale(b:count_cache)
    return s:GetCachedMatchCount(b:count_cache)
  endif

  " use cached values if nothing has changed since the last check
  if b:count_cache.pattern == @/ && b:count_cache.changedtick == b:changedtick
    return s:GetCachedMatchCount(b:count_cache)
  endif

  " don't count matches that aren't being searched for
  if @/ == ''
    let b:count_cache.pattern     = ''
    let b:count_cache.match_count = 0
    let b:count_cache.changedtick = b:changedtick
  else
    try
      let l:view = winsaveview()  " don't let anything change while we do this
      set eventignore=all  " don't execute autocmds

      " turn off hlsearch if enabled
      let l:hlsearch = &hlsearch
      if l:hlsearch | set nohlsearch | endif

      " this trick counts the matches
      redir => l:match_output
      silent! execute s:match_command
      redir END

      if len(l:match_output) < 0 " no output means nothing was found
        let l:match_count = 0
      else                       " otherwise the first word contains the count
        let l:match_count = split(l:match_output)[0]
      endif

      let b:count_cache.pattern     = @/
      let b:count_cache.match_count = l:match_count
      let b:count_cache.changedtick = b:changedtick
    catch
      " if there's an error, let's pretend we don't see anything
      let b:count_cache.pattern     = @/
      let b:count_cache.match_count = 0
    finally
      set eventignore=
      if l:hlsearch | set hlsearch | endif
      call winrestview(l:view)
    endtry
  endif

  return s:GetCachedMatchCount(b:count_cache)
endfunction

if exists('g:loaded_airline') " we can use airline
  call airline#parts#define('match_count', { 'function': 'GetMatchCount' })
  let g:airline_section_b = airline#section#create(['match_count'])
else
  set laststatus=2
  set ruler
  let &statusline='%{GetMatchCount()} ' . &statusline
endif

command! -nargs=0 ToggleMatchCounting call <SID>ToggleMatchCounting()
