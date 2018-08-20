" Author:      Emily St
" Script:      statusline-match-count
" Description: Calculates and displays a statusline item which counts
"              number of times the current search pattern occurs in the
"              current buffer. Written both for vim-airline and for the
"              generic statusline.
" License:     GPLv3
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.

" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.

" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <https://www.gnu.org/licenses/>.

scriptencoding utf-8

" time during which cached values get reused
let s:cache_timeout_in_seconds = 0.25

" max file size before automatically disabling
let s:max_file_size_in_bytes = 10 * 1024 * 1024

" default sentinel values representing an unused cache
let s:sentinel_values = {
      \   'pattern':     -1,
      \   'bufnr':       -1,
      \   'changedtick': -1,
      \   'match_count': -1,
      \   'last_run':    -1
      \ }

let s:count_cache = s:sentinel_values

" gdefault option inverts meaning of 'g' flag on patterns
if &gdefault
  let s:match_command = '%s//&/ne'
else
  let s:match_command = '%s//&/gne'
endif

" return 1 if the cache has never been used, 0 otherwise
function! s:AreSentinelValuesCached()
  if s:count_cache == s:sentinel_values
    return 1
  else
    return 0
  endif
endfunction

" return 1 if file is too large to process, 0 if not
" (if match counting has been toggled on manually, we ignore file size)
function! s:IsLargeFile()
  if get(b:, 'match_count_force', 0)
    return 0
  else
    if getfsize(expand(@%)) >= s:max_file_size_in_bytes
      return 1
    else
      return 0
    endif
  endif
endfunction

" return 1 if cache is stale, 0 if not
function! s:IsCacheStale()
  " hit the cache the first time around
  if s:AreSentinelValuesCached()
    let s:count_cache['last_run'] = reltime()
    return 0
  endif

  let l:seconds = s:cache_timeout_in_seconds
  let l:micros = s:cache_timeout_in_seconds * 1000000

  if has('reltime')
    try
      " not calling reltimefloat for perf reasons
      let l:time_elapsed = reltime(s:count_cache['last_run'])
      if type(l:time_elapsed) != 3          " error (treat as cache miss)
        let s:count_cache['last_run'] = reltime()
        return 1
      elseif l:time_elapsed[0] > l:seconds  " cache miss (more than a second)
        let s:count_cache['last_run'] = reltime()
        return 1
      elseif l:time_elapsed[1] > l:micros   " cache miss (less than a second)
        let s:count_cache['last_run'] = reltime()
        return 1
      else                                  " cache hit
        return 0
      endif
    catch                                   " error (treat as cache miss)
      let s:count_cache['last_run'] = reltime()
      return 1
    endtry
  else
    try " not the ideal fallback -- seconds-wise precision only
      let l:time_elapsed = s:count_cache['last_run'] - localtime()
      if l:time_elapsed > l:seconds         " cache miss (more than a second)
        let s:count_cache['last_run'] = localtime()
        return 1
      else                                  " cache hit
        return 0
      endif
    catch                                   " error (treat as cache miss)
      let s:count_cache['last_run'] = localtime()
      return 1
    endtry
  endif
endfunction

" use the cache and window width to construct the status string
function! s:GetCachedMatchCount()
  if @/ == ''
    return ''
  else
    " try to adapt to window width
    if winwidth(0) >= 120
      return s:count_cache['match_count'] . ' matches of /' . s:count_cache['pattern'] . '/'
    elseif winwidth(0) < 120 && winwidth(0) >= 100
      return s:count_cache['match_count'] . ' matches'
    else
      return s:count_cache['match_count']
    endif
  endif
endfunction

" allow forcing on or off match-counting for a buffer (also allows
" overriding the file-size detection, hence the `force` variable)
function! ToggleMatchCounting()
  if !has_key(b:, 'match_count_enable')
    let b:match_count_enable = 1
  endif

  if !has_key(b:, 'match_count_force')
    let b:match_count_force = 0
  endif

  if get(b:, 'match_count_force', 0)
    let b:match_count_force = 0
    let b:match_count_enable = 0
    " clear cache?
  else
    let b:match_count_force = 1
    let b:match_count_enable = 1
  endif

  redrawstatus!
endfunction

" calculate the match count
function! GetMatchCount()
  " do nothing if disabled in this buffer
  if !get(b:, 'match_count_enable', 1)
    return ''
  endif

  " don't even warm up the cache for large files
  if s:IsLargeFile()
    return ''
  endif

  " only update if enough time has passed
  if !s:IsCacheStale()
    return s:GetCachedMatchCount()
  endif

  " use cached values if nothing has changed since the last check
  if s:count_cache['pattern'] == @/
        \ && s:count_cache['bufnr'] == bufnr('%')
        \ && s:count_cache['changedtick'] == b:changedtick
    return s:GetCachedMatchCount()
  endif

  " something has changed, so we update the cache
  let s:count_cache['pattern']     = @/
  let s:count_cache['bufnr']       = bufnr('%') " current buffer number
  let s:count_cache['changedtick'] = b:changedtick " buffer change count

  " don't count matches that aren't being searched for
  if @/ == ''
    let s:count_cache['match_count'] = 0
    return s:GetCachedMatchCount()
  else
    try
      let l:view = winsaveview()  " don't let anything change while we do this
      set eventignore=all  " don't execute autocmds

      " turn off hlsearch if enabled
      let l:hlsearch = &hlsearch
      if l:hlsearch
        set nohlsearch
      endif

      " this trick counts the matches
      redir => l:match_output
      silent execute s:match_command
      redir END

      if len(l:match_output) < 0 " no output means nothing was found
        let l:match_count = 0
      else                       " otherwise the first word contains the count
        let l:match_count = split(l:match_output)[0]
      endif

      let s:count_cache['match_count'] = l:match_count
      return s:GetCachedMatchCount()
    catch
      " if there's an error, let's pretend we don't see anything (but
      " this performs badly because it will miss the cache)
      let s:count_cache['match_count'] = 0
      let s:count_cache['pattern'] = ''
      return s:GetCachedMatchCount()
    finally
      if l:hlsearch
        set hlsearch
      endif
      set eventignore=
      call winrestview(l:view)
    endtry
  endif
endfunction

if exists('g:loaded_airline') " we can use airline
  call airline#parts#define('match_count', { 'function': 'GetMatchCount' })
  let g:airline_section_b = airline#section#create(['match_count'])
else
  set laststatus=2
  set ruler
  let &statusline='%{GetMatchCount()} ' . &statusline
endif

command! ToggleMatchCounting call ToggleMatchCounting()
